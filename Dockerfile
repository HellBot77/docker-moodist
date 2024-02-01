FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/remvze/moodist.git && \
    cd moodist && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node:alpine as build

WORKDIR /moodist
COPY --from=base /git/moodist .
RUN npm install && \
    npm run build

FROM pierrezemb/gostatic

COPY --from=build /moodist/dist /srv/http
EXPOSE 8043
