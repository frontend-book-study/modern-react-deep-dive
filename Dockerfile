FROM node:18-alpine AS deps

WORKDIR /app

COPY package.json ./package.json
COPY package-lock.json ./package-lock.json

RUN npm ci

FROM node:18-alpine AS build

WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules
COPY . ./

RUN npm run build

FROM node:18-alpine AS runner

COPY --from=build /app/public ./public
COPY --from=build /app/.next/standalone ./
COPY --from=build /app/.next/static ./.next/static

EXPOSE 3000

ENTRYPOINT ["node", "server.js"]
