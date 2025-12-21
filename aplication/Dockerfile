FROM node:20-alpine

WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm ci --omit=dev || npm i --omit=dev

COPY . .
ENV PORT=8080
EXPOSE 8080

RUN addgroup -S app -g 10001 && adduser -S app -u 10001 -G app
USER 10001:10001

CMD ["npm","start"]
