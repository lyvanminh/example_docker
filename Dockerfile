FROM ruby:2.7.1

# Install apt based dependencies required to run Rails as
# well as RubyGems. As the Ruby image itself is based on a
# Debian image, we use apt-get to install those.
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

#RUN apt-get update && apt-get install -y \
#  build-essential \
#  nodejs
RUN apt-get install -y imagemagick
# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
RUN mkdir -p /app
WORKDIR /app

# Copy the Gemfile as well as the Gemfile.lock and install
# the RubyGems. This is a separate step so the dependencies
# will be cached unless changes to one of those two files
# are made.
COPY Gemfile Gemfile.lock ./
COPY . ./

RUN gem install bundler -v '1.3.0' && bundle install --jobs 20 --retry 5

# Copy the main application.

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Expose port 3000 to the Docker host, so we can access it
# from the outside.
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]

# The main command to run when the container starts. Also
# tell the Rails dev server to bind to all interfaces by
# default.
#RUN bundle install
