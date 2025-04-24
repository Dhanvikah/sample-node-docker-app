# Use Node.js base image
FROM node:16

# Create app directory
WORKDIR /usr/src/app

# Copy app files
COPY . .

# Install dependencies
RUN npm install

# Expose the port and run the app
EXPOSE 3000
CMD [ "node", "index.js" ]
