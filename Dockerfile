FROM node:lts-alpine as build-deps
WORKDIR /usr/src/app
COPY package.json yarn.lock ./
RUN yarn
COPY . ./
RUN yarn build

# Stage 2 - the production environment
FROM node:lts-alpine
COPY --from=build-deps /usr/src/app/build /build
COPY --from=build-deps /usr/src/app/server /server
WORKDIR /server
RUN yarn
CMD [ "node", "index.js" ]