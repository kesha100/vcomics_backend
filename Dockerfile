# Build Stage
FROM node:18 AS build

# Install dependencies needed for the build process
RUN apt-get update && apt-get install -y python3 python3-dev

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application files
COPY . .

# Generate Prisma client
RUN npm run prisma:generate

# Build the application
RUN npm run build

# Production Stage
FROM node:18

# Install Redis
RUN apt-get update && apt-get install -y redis-server

# Set the working directory
WORKDIR /app

# Copy only the necessary files from the build stage
COPY --from=build /app/dist ./dist
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/prisma ./prisma
COPY package*.json ./

# Install production dependencies
RUN npm install

# Copy a custom entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose port
EXPOSE 3000

# Use the custom entrypoint script
ENTRYPOINT ["/entrypoint.sh"]