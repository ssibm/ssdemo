FROM node:9-alpine
RUN mkdir -p /broker
COPY common /broker/common
COPY config /broker/config
COPY app.js package.json /broker/
WORKDIR /broker
RUN npm install
EXPOSE 3080
CMD ["npm", "start"]
