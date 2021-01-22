#/bin/bash

BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

printf "Run this as a normal user without sudo because it uses home directories, know that you're going to miss attestations when you update, best to put it off as long as possible.";

printf "Go here ${BLUE}https://github.com/sigp/lighthouse/releases${NC}, copy the link for ${YELLOW}x86_64-unknown-linux-gnu-portable${NC}.tar.gz

";



read -p 'Enter the direct link for the x86_64 portable update: ' github

echo $github

printf '\n\n';

filename=$(basename $github)

wget $github

tar xvf $HOME/$filename

$HOME/lighthouse --version

printf "${YELLOW}CHECK FOR THE CORRECT VERSION NUMBER ABOVE BEFORE ACCEPTING THIS UPDATE! FAILING TO VERIFY THIS WILL BREAK THINGS!${NC}\n\n";

printf "Do you want to stop the lighthouse beacon chain and validator to update it? ";
select yn in "Yes" "No"; do
    case $yn in
        Yes )

	sudo systemctl stop lighthousevalidator

	sudo systemctl stop lighthousebeacon

	sudo mv /usr/local/bin/lighthouse /usr/local/bin/`/usr/local/bin/lighthouse --version | head -n 1 | sed 's/ /_/' | sed 's/L/l/'`

	sudo mv $HOME/lighthouse /usr/local/bin/

	sudo systemctl daemon-reload
	
	sudo systemctl start lighthousebeacon

	sudo systemctl start lighthousevalidator

	rm $HOME/$filename

	sudo tail -f /var/log/syslog

	break;;
        No ) echo 'You selected No, this script will terminate.' ; exit;;
    esac
done
