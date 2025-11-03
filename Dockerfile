FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
# change port for every new build
EXPOSE 1000
CMD ["node", "app.js"]