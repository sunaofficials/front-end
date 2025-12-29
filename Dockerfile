FROM node:18-alpine AS build

WORKDIR /app

# copy package files first (cache-friendly)
COPY package*.json ./
COPY yarn.lock ./

RUN yarn install --frozen-lockfile

# copy rest of the app
COPY . .

# Sock Shop frontend is a Node server (not React static build)
# so NO npm run build required

# -------- Runtime stage --------
FROM node:18-alpine

WORKDIR /app

COPY --from=build /app .

EXPOSE 8079
CMD ["node", "server.js"]
