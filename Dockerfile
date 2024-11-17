# Use the Node.js 16 Alpine image
FROM node:16.14-alpine

# Set the working directory
WORKDIR /app-backend

# Copy package.json and package-lock.json into the working directory
COPY package*.json ./

# Install Node.js dependencies
RUN npm install

# Copy all remaining application files into the container
COPY . .

# Expose the application port (replace with the actual port your backend uses)
EXPOSE 3000

# Run the application
CMD ["npm", "start"]
