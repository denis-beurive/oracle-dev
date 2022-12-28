#!/bin/bash
#
# The set -e option instructs bash to immediately exit if any command has a
# non-zero exit status. 

set -e

if [ -z ${HOME+x} ]; then
    echo "FATAL: variable HOME is NOT defined! What's wrong!";
    exit 1
fi

# -------------------------------------------------
# Configuration
# -------------------------------------------------

# Doc: https://www.thedigitalcatonline.com/blog/2018/04/25/rsa-keys/
#
# Note: the last "field" of the public key (here: "denis@lab") is is a comment, and can be 
#       changed or ignored at will. It is set to "user@host" by default by ssh-keygen.
#       See: https://serverfault.com/questions/743548/what-significance-does-the-user-host-at-the-end-of-an-ssh-public-key-file-hold

SSH_PUB_KEY=$(cat <<"EOS"
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6rAizPSuknx5LH6QAHVlPBcu44/euG42MEJ2sPtC2Ht5Ln9sI7T2xZxvRYTWXCEzGv3yB16ZH3zJm5liTP+V7CmahgpfagX0gm6/3+EFaKeRNQ1Lvh0d7rVO8L1DpCOG3oP952flboy2U7SuKcNHjNo+a4NYInkz+wqjnFEERbahyBgKLsKo6fyTu9g9gSIxBorsbDud37fQ6VJ424Ub69gRELRTQbmcUhJEuLATgYHx0CZPRopEU5JSdBVq6UfkcnQ9AGTH5VdhLmLnj04NEqyhA1cNu2H5E7L/Sx7xPNGoUhzmN4Z/EhvVHqSO/YfzZnxuMcmTJfIrsVXajR/xb denis@lab
EOS
)
declare -r SSH_PUB_KEY

# Note: The private key must be store with file permission "600" (chmod 600 /path/to/file)

SSH_PRIV_KEY=$(cat <<"EOS"
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAuqwIsz0rpJ8eSx+kAB1ZTwXLuOP3rhuNjBCdrD7Qth7eS5/b
CO09sWcb0WE1lwhMxr98gdemR98yZuZYkz/lewpmoYKX2oF9IJuv9/hBWinkTUNS
74dHe61TvC9Q6Qjht6D/edn5W6MtlO0rinDR4zaPmuDWCJ5M/sKo5xRBEW2ocgYC
i7CqOn8k7vYPYEiMQaK7Gw7nd+30OlSeNuFG+vYERC0U0G5nFISRLiwE4GB8dAmT
0aKRFOSUnQVaulH5HJ0PQBkx+VXYS5i549ODRKsoQNXDbth+ROy/0se8TzRqFIc5
jeGfxIb1R6kjv2H82Z8bjHJkyXyK7FV2o0f8WwIDAQABAoIBAFuLusiMGzckgaq9
3aPgwMesQ/hsdC8CfCxQicLLG3f1M3dK8hQypKq3skDAt5NWErD1f439wCJHJ2Sn
WpD8KQJqW2KhtO8HyeGP+IBXU1VwbfImLioh4cCZhBMp8TgXjvqLDj8n0s5J/DSp
C01dftE7FLoTwWOAnqnhtQt+N1rf4eA6ZONnGGWJc58h3nZr1MbwMaME869btjXS
mnD8j+BSL4dpyNVk20Lr8oLmm2DkYQpc2e4qBu0apuX6MZXU59PkXvgFNw6iZ94t
6kc/q5xVunM8jdVQbdgC+1zBYvBGWO2Ecfqst+IrNf0aQClZ+q3sCgO9pIjuRIGO
XYjE8WECgYEA330REFVPtPKhQU7D653m6N8NMhIDp/2qx4wuKTJfZyFQKFYbMC2s
dlUMLg6yWjBhlp7T1HPgD6LcPbZhMpBLC7ne04gvniKf6BaGjJDpu8ifGnlr1XdT
GcO8+mbEn9lGnRVR+i0M4BNU/ggiT3FSgOi2UFUeNR4BGRala7NdY8cCgYEA1dPi
I7WhUXLM1aJh4tM3pv7B0SRkPrXg3z8sWWXRS8lyPwDz6QoBHWLr5wDRAqibIHdl
sgZFWTZgf2wxNRFIjANqIV3XS/6GWbmY0PuJL9wgxdykEQ/41I4NPUBz5nGV62zE
BNt5EMEh+HTT27MjHCs5dyNCZ+Ih9/gjUlf8Os0CgYA0KvuKtn9Om7xshDhTjZ5T
CY4I/A+CbUIqJly4HRwL9MjDQaZDDsZNMPkQ3zleuCBvik+kLhBFVhzXAvWZWflK
mW6cLhP/c9Gj2W467bDBtsj84w7620m4n+pDAS4wqgVDsbBbF50DyT9ztO5dYPSD
Rs8X3WaZu5FCC/k9NLc+DQKBgAwnT+oxr6qeeNAHu8KVuMsQHdoSVHRQCCkIQTAP
nnbNS2YTWsm7HNcbwUbPABJDnRWaU7hrrNNmSNPVRXK7ucDjjMu6trsGC4LcDriK
I4EJ5P76DIU/wCfsrwn1OOE3QYsxEm8oPlhaceDaWxRYuT0no8uGwIaBDuc2PmO2
xopdAoGAUjTmdKTaLCXTxa1bIiTTp++sG6wo9WWY0iPyK2CZg6bTt+iUKqcRVLmi
oYvYkHykqCyZQOWKnSjM/Hu4LlbH88jVa/9AClALP9CupUWWJDSRkLuQgjFraPrk
kTLvjpvfekRQdAIsPN9uHCEUnKtgKQKCTSwPCmE2nL1EVj7SLOw=
-----END RSA PRIVATE KEY-----
EOS
)
declare -r SSH_PRIV_KEY

# -------------------------------------------------
# End of configuration
# -------------------------------------------------

declare -r SSH_DIR="${HOME}/.ssh"

# Create the ".ssh" directory if necessary.
if [ ! -d "${SSH_DIR}" ]; then
    echo "Create directory \"${SSH_DIR}\""
    mkdir "${SSH_DIR}"
    chmod 0700 "${SSH_DIR}"
fi


cd "${SSH_DIR}"
echo "${SSH_PUB_KEY}" >> authorized_keys
chmod 0444 authorized_keys
cd "${HOME}"

