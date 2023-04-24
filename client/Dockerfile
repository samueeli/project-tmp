FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
ARG VITE_API_URL
ENV VITE_API_URL=$VITE_API_URL
RUN echo "VITE_API_URL is set to $VITE_API_URL"
RUN npm ci
COPY . .
RUN npm run build
RUN npm install -g serve
EXPOSE 5173
CMD ["serve", "-s", "dist", "-l", "5173"]
