FROM node:alpine

EXPOSE 80

COPY . .

RUN npm install

ENTRYPOINT [ "npm", "run", "start:prod" ]