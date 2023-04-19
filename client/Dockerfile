FROM node:16-alpine
WORKDIR /app
COPY package*.json ./
ENV VITE_API_URL="http://samulin-server.azurewebsites.net/api/hello"
RUN npm ci
COPY . .
RUN npm run build
RUN npm install -g serve
EXPOSE 5173
CMD ["serve", "-s", "dist", "-l", "5173"]
