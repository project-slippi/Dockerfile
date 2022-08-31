FROM devkitpro/toolchain-base AS builder

RUN apt-get update
RUN apt-get install -y golang
RUN git clone https://github.com/JLaferri/gecko
WORKDIR /gecko
RUN go build .

FROM devkitpro/toolchain-base

LABEL maintainer="Nikki <nikki@slippi.gg>"

RUN dkp-pacman -Syyu --noconfirm gamecube-dev wii-dev wiiu-dev gba-dev && \
  dkp-pacman -S --needed --noconfirm `dkp-pacman -Slq dkp-libs | grep '^ppc-'` && \
  dkp-pacman -Scc --noconfirm
RUN apt-get update
RUN apt-get install -y "g++-multilib"
ENV DEVKITPPC=${DEVKITPRO}/devkitPPC
ENV DEVKITARM=${DEVKITPRO}/devkitARM
COPY --from=builder /gecko/gecko /usr/bin/
