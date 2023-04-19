FROM node:16-alpine
WORKDIR /app
COPY package*.json ./
ENV VITE_API_URL=${VITE_API_URL}
RUN npm ci
COPY . .
RUN npm run build
RUN npm install -g serve
EXPOSE 5173
CMD ["serve", "-s", "dist", "-l", "5173"]
