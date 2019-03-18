FROM node:9-alpine
RUN mkdir -p /broker
COPY common /broker/common
COPY config /broker/config
#COPY public /broker/public
COPY routes /broker/routes
#COPY tests /broker/tests
COPY app.js package.json /broker/
WORKDIR /broker
RUN npm install
EXPOSE 3080
CMD ["npm", "start"]
