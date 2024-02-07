### Windows 11
## Adding SSH to giyhub

# Generate ssh token on your windows machine
# `-t rsa` defines the type of key
# `-b 4096` defines the bits of key
# -C is commend or label
ssh-keygen -t rsa -b 4096 -C "shuxratovumidjon03@gmail.com"

# Open and copy the code
cat ~/.ssh/id_rsa.pub

# Past it into github SSH input