function mkcdir() {
    mkdir -p "$@" && cd "$@"
}

function mvg() {
    mv $1 $2 && cd $2
}

# Usage : replace "string_old" "string_new" /home/users/me/test
# Recursively replace string_old by string_new in given directory and subs
function replace() {
    cyan=$(tput setaf 37)
    green=$(tput setaf 77)
    white=$(tput setaf 15)
    old=$1
    new=$2
    old_esc="$(echo "$old" | sed 's/[^-A-Za-z0-9_]/\\&/g')"
    new_esc="$(echo "$new" | sed 's/[^-A-Za-z0-9_]/\\&/g')"
    dir=$(dirname "$3")
    echo "Replacing $cyan$old$white by $cyan$new$white in directory $cyan$dir$white ..."
    grep -rli "$old" * | xargs -i@ sed -i "s/$old_esc/$new_esc/g" @
    echo $green
    echo "Done"
}

function quickdiff() {
    from=${1:-master}
    to=${2:-develop}
    ls | xargs -n 1 -I {} bash -c "cd {}; echo ''; echo ''; echo '--- {} ---'; git --no-pager log $from..$to --pretty=format:'%h : %s' --graph; cd ..;"
}

function lastversion() {
    ls | xargs -n 1 -I {} bash -c "cd {}; echo '--- {} ---'; git tag -l $1*; cd ..;"
}

function getAnsiblePasswordHash() {
    MSG="msg={{ '"
    MSG+=$1
    MSG+="' | password_hash('sha512', 'kouignamannaubeursale') }}"

    ansible localhost, -m debug -a "$MSG"
}

function updateAwsCliForLinux() {
    setupdir=$(mktemp -d)
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.0.30.zip" -o "${setupdir}/awscliv2.zip"
    unzip "${setupdir}/awscliv2.zip" -d $setupdir
    sudo "${setupdir}/aws/install" --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
    rm -rf $setupdir
}

function patchMolecule() {
    molVersion=$(brew info --installed --json | jq -r '.[] | select(.name == "molecule") | .versions.stable')
    cd /home/linuxbrew/.linuxbrew/Cellar/molecule/$molVersion
    libexec/bin/pip uninstall docker-py
    libexec/bin/pip install molecule-docker --prefix libexec
    cd -
}
