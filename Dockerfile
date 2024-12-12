FROM amazonlinux:2023
COPY ./Connect4.x86_64 /
RUN chmod +x ./Connect4.x86_64
CMD ./Connect4.x86_64