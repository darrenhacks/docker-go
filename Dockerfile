# syntax=docker/dockerfile:1

#
# See https://docs.docker.com/language/golang/build-images/
# for more information on how this Dockerfile was constructed.
#

#
# The base build container
#
FROM golang:1.18-buster AS build-image

WORKDIR /

#
# Add build files to the build container and pull
# down dependencies.
#
COPY Makefile ./
COPY go.mod ./
# You'll need this when there are actually dependencies.
# COPY go.sum ./
RUN go mod download

#
# Copy the source into the build container.
#
COPY *.go ./

#
# Buld the application.
#
RUN make

#
# Add a non-priveliged user account. I'm using a specific ID just so
# I can prove I'm running as that user inside the application.
#
RUN addgroup gouser &&  \
    adduser --ingroup gouser --uid 19998 --shell /bin/false gouser &&  \
    cat /etc/passwd | grep gouser > /etc/passwd_gouser

#
# Construct the runtime container.
#
FROM scratch
WORKDIR /

#
# Copy the /etc/passwd file with the user I want
# to run as defined in it.
#
COPY --from=build-image /etc/passwd_gouser /etc/passwd

#
# Copy the application itself from the build
# container to the runtime container.
#
COPY --from=build-image /docker-go docker-go

USER gouser

#
# Runs the application.
#
ENTRYPOINT ["/docker-go"]
