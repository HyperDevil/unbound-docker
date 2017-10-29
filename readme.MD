This is an Unbound DNS over TLS docker image.
All settings for unbound are in the unbound.sh file.
You need valid certificates for your server (eg. truecrypt for free), certificates in this repo are self signed.

Build your container:
docker build -t "yourname:unbound" unbound-docker

Start your container (your container will run in the background):
docker run -d -p 853:853 --restart=always "yourname:unbound"

To extract base64 key from server, run this command:
echo | openssl s_client -connect '127.0.0.1:853' 2>/dev/null \
| openssl x509 -pubkey -noout | openssl pkey -pubin -outform der | \
openssl dgst -sha256 -binary | openssl enc -base64

