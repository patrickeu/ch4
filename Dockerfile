FROM node:lts-alpine3.20 AS base
WORKDIR /usr/src/app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build

FROM base AS builder
WORKDIR /app
COPY --from=base /usr/src/app/node_modules ./node_modules
COPY . .
RUN npm run build

FROM base AS prod
WORKDIR /usr/src/app
COPY --from=builder /usr/src/app/dist/ ./
COPY package.json package-lock.json ./
RUN npm install
CMD npm run dev