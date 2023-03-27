FROM node:18.15.0-bullseye-slim

RUN apt-get update

RUN mkdir /home/build
WORKDIR /home/build

ARG UID=45006
RUN adduser --disabled-password --no-create-home --uid $UID --gecos '' build

ARG npm_token

ADD .npmrc.tpl /root
RUN sed -i 's/NPM_TOKEN/'"$npm_token"'/' /root/.npmrc.tpl
RUN mv /root/.npmrc.tpl .npmrc

COPY . .
RUN chown -R build:build /home/build
USER build

ENV CI=true

RUN yarn install
RUN yarn test
RUN yarn build
RUN yarn run publish
