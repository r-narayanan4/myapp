# Use the official Ruby image
FROM ruby:3.1.2

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Set working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the rest of the application
COPY . .

# Copy entrypoint script into the image
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# Expose port 3000
EXPOSE 3000

# Set the entrypoint
ENTRYPOINT ["entrypoint.sh"]

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]

