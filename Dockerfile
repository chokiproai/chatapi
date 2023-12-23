# Start with the Debian Bullseye Slim image
FROM debian:bullseye-slim

# Update package files and install Curl
RUN apt-get update && apt-get install -y curl

# Download the latest version of Ninja from GitHub
RUN version=$(basename $(curl -sL -o /dev/null -w %{url_effective} https://github.com/gngpp/ninja/releases/latest)) \
    && base_url="https://github.com/gngpp/ninja/releases/expanded_assets/$version" \
    # Get the URL of the distribution based on x86_64 CPU and musl libc
    && latest_url=https://github.com/$(curl -sL $base_url | grep -oP 'href=".*x86_64.*musl\.tar\.gz(?=")' | sed 's/href="//') \
    # Download the tar.gz file and extract it
    && curl -Lo ninja.tar.gz $latest_url \
    && tar -xzf ninja.tar.gz

# Set the Chinese language environment and do not interact with APT
ENV LANG=C.UTF-8 DEBIAN_FRONTEND=noninteractive LANG=en-US.UTF-8 LANGUAGE=en-US.UTF-8 LC_ALL=C

# Copy the main `ninja` file to /bin so it can be run from anywhere
RUN cp ninja /bin/ninja

# Create necessary folders and set access rights
RUN mkdir /.gpt3 && chmod 777 /.gpt3
RUN mkdir /.gpt4 && chmod 777 /.gpt4
RUN mkdir /.auth && chmod 777 /.auth
RUN mkdir /.platform && chmod 777 /.platform

# By default when running an image, it will run ninja
CMD ["/bin/ninja","run"]
