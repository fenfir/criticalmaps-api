FROM node:6.2.1

RUN groupadd -r node && useradd -r -g node node

ENV APP_DIR /usr/src/app/

RUN mkdir -p $APP_DIR
WORKDIR $APP_DIR

COPY package.json $APP_DIR
RUN npm install --silent

COPY . $APP_DIR

RUN chown -R node:node $APP_DIR

EXPOSE 3000

CMD [ "npm", "start" ]
