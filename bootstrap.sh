#!/usr/bin/env sh

set -eu

function printinfo { echo "\033[1;33m[i]\033[0m ${1}"; }
function printwarn { echo  "\033[1;31m[!]\033[0m ${1}"; }
function printquestion { echo "\033[1;32m[?]\033[0m ${1}"; }
function printsuccess { echo "\033[1;32m[✔]\033[0m ${1}"; }

printinfo "Bootstrapping..."

if [[ ! -s ./ansible/.vault_pass.txt ]]; then
    printwarn "No ./ansible/.vault_pass.txt found or it's empty!"
    echo " "
    printquestion "Fill in your Vault pass and press \033[1m[ENTER]\033[0m: "
    read vault_pass
    echo "${vault_pass}\n" > ./ansible/.vault_pass.txt
fi

docker network create satis >/dev/null 2>&1 || true

printinfo "Running ansible-playbook dev..."
ansible-playbook ./ansible/play/dev.yml --verbose

if [[ -d ./.git ]]; then
    printwarn "Project already initialized... skipping..."
else
    printinfo "Encrypting vars before committing..."
    ansible-vault encrypt ansible/envs/*/*/*/vault.yml 2>/dev/null || true
    printsuccess "Successfully encrypted vars."

    printinfo "Initializing project and performing initial commit..."
    git init 1>/dev/null
    git add . 1>/dev/null
    git commit -am 'Project scaffolded based on laravel-skeleton' 1>/dev/null
    printsuccess "Successfully initialized git."
fi

printsuccess "Done bootstrapping!"
