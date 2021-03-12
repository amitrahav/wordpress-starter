#!/usr/bin/env bash
if [ -z ${WPCONFIG+x} ]; then WPCONFIG=/Users/amit/.wpconfig; fi
THEMENAME="${PWD##*/}"

getDefualtValues(){
    echo "getting defualt values..."
    if [ -f "$WPCONFIG" ]; then
        source "$WPCONFIG"
    else
        echo "Please create and set your WPCONFIG file on ${WPCONFIG} or change path by WPCONFIG varible"
    fi
}

taskReplace() {
    local search='<themesOrPlugins>'
    local replace="$Building"+"s"
    # Note the double quotes
    sed -i "" "s/${search}/${replace}/g" .vscode/tasks.json
}

taskReplaceThemeName(){
    local search='${workspaceFolderBasename}'
    if [ -z {$THEMENAME+x} ] && [ $THEMENAME -ne "${PWD##*/}"]; then
        local replace="$THEMENAME";
        # Note the double quotes
        sed -i "" "s/${search}/${replace}/g" .vscode/tasks.json
    fi
}

isYes(){ #PARMS answer
    if [[ $1 == "yes" ]] || [[ $1 == "Yes" ]] || [[ $1 == "טקד" ]] || [[ $1 == "כן" ]]; then
        return 0 # 0 == True in bash
    fi
    return 1 # 1 == False in bash
}

gitignoreAdd(){ #Params: WhatShoulIADD
    echo -e "\n${1}" >> .gitignore
}

initializingEnv(){
    echo "Copy env file"
    if [ ! -f '.env.example' ]; then
        cp .env.example .env
    fi
}

envReplace() { #Params: ACF_PRO_KEY,
    
    if [ -z {$1+x} ]
    then
        echo "Please set ACF_PRO_KEY value on your ~/.wpconfig file"
    else
        local search='youracfkeyhere'
        local replace="$1"
        # Note the double quotes
        sed -i "" "s/${search}/${replace}/g" .env
    fi
    
}

composerUpdatAndInstall(){
    composer install && composer update
    echo "<?php require_once(__DIR__ . '/advanced-custom-fields-pro/acf.php');" > wp-content/mu-plugins/advanced-custom-fields-pro.php
}

gitignoreUpdate(){
    echo '\n/data/\n/data/logs\n!/data/.gitkeep\n!/data/logs/.gitkeep\nenvironments\nscripts\n*.example\n*.lock\nlogs.ini\nrobots.txt\n# HERE GOES YOUR APP EXCEPTION' >> .gitignore
}

buildingDialog(){
    echo "Hello, What Are You Building?"
    local options=("Theme" "Plugin")

    select opt in "${options[@]}"; do
        case $REPLY in
            "1")
                Building="theme"
                return 1
            ;;
            "2")
                Building="plugin"
                return 1
            ;;
            *) echo "invalid option $REPLY";;
        esac
    done
}

pullGitDialog(){ #Params: RepoUrl, relativePath
    if [ -z {$2+x} ]; then
        relativePath = "./${2}"
    else
        relativePath = ""
    fi;
    
    git clone ${1} $relativePath
}

gettingRepoDialog(){
    local repo;
    local relPath;
    echo "Paste the repo Url to clone from"
    read repo
    echo "Relative path to clone into (leave blank for git defualt behivior)"
    read relPath
    pullGitDialog $repo $relPath
    
}

initializeThemeDialog(){
    
    echo "New Theme Name (if you leave it blank it will be the name of your project root dir)"

    read newThemeName
    if [ -z {$newThemeName+x} ]
    then
        $THEMENAME = $newThemeName
    fi
    mkdir wp-content/themes/$THEMENAME
    taskReplaceThemeName
    gitignoreAdd "!/wp-content/themes/${THEMENAME}"
    
    declare -a dirsToCreate=("sass" "partials" "assets" "js" "includes")
    for i in ${dirsToCreate[@]}; do
        mkdir wp-content/themes/$THEMENAME/${i}
    done
    
    touch "wp-content/themes/${THEMENAME}/includes/acf-register.php" "wp-content/themes/${THEMENAME}/includes/cpt-register.php" 
    git clone https://gist.github.com/ebe0f942b52a656c92c9ffccd16151be.git "wp-content/themes/$THEMENAME/gist" && mv "wp-content/themes/$THEMENAME/gist/index-starter" "wp-content/themes/$THEMENAME/index.php" && rm -rf "wp-content/themes/$THEMENAME/gist/"
    git clone https://gist.github.com/47482e834c2d03a3ca3444114909cbc6.git "wp-content/themes/$THEMENAME/gist" && mv "wp-content/themes/$THEMENAME/gist/script-starter" "wp-content/themes/$THEMENAME/js/app.js" && rm -rf "wp-content/themes/$THEMENAME/gist/"
    
    echo -e "/*!\nTheme Name: ${THEMENAME}\nTheme URI:\nDescription: A custom theme for the ${THEMENAME} project\nAuthor: TheTwo LTD.\nAuthor URI: http://the-two.co\nVersion: 1.0\nTags: clean, advanced, responsive, great\n*/" > wp-content/themes/${THEMENAME}/sass/style.scss
    echo -e '<!DOCTYPE html>\n<html>\n\n<head>\n   <title>\n        <?php\n        wp_title("|", true, "right");\n        bloginfo("name");\n        ?>\n    </title>\n    <meta charset="utf-8">\n    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.3, user-scalable=1">\n    <?php wp_head(); ?>\n</head>' > wp-content/themes/${THEMENAME}/header.php
    echo -e '<footer>\n\n\n</footer>\n<?php wp_footer(); ?>\n</body>\n\n</html>' > wp-content/themes/${THEMENAME}/footer.php
    
    echo -e "Wanna Talk About Auto Inserting Functions? (Yes to continue)"
    read functions

    # Function File Addition
    local functionsFilePath="wp-content/themes/${THEMENAME}/functions.php"
    declare -a styleNames=("main")
    declare -a styles=("get_template_directory_uri() . '/style.css'")
    declare -a scriptNames=("main")
    declare -a scripts=("get_template_directory_uri() . '/js/app.js'")
    declare -a otherFunctions=()
    touch $functionsFilePath
    # # Any Other?
    if isYes $functions ; then
        echo "Add font awesome? (Yes/No)"
        read fontAwesome
        if isYes $fontAwesome ; then
            styleNames[${#styleNames[@]}]="prefix-font-awesome"
            styles[${#styles[@]}]='"//netdna.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css"'
        fi
        
        echo "Add Wow.js? (Yes/No)"
        read wowJs
        if isYes $wowJs ; then
            styleNames[${#styleNames[@]}]='wowjs'
            styles[${#styles[@]}]='"//cdnjs.cloudflare.com/ajax/libs/wow/1.1.2/wow.min.js"'
        fi
        
        echo "Add Slick.js? (Yes/No)"
        read slickJs
        if isYes $slickJs ; then
            scriptNames[${#scriptNames[@]}]='slick'
            scripts[${#scripts[@]}]='"//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"'
            styleNames[${#styleNames[@]}]='slickTheme' 
            styleNames[${#styleNames[@]}]='slick' 
            styles[${#styles[@]}]='"//cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.9.0/slick-theme.min.css"'
            styles[${#styles[@]}]='"//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"' 
        fi
        
        echo "Add Vivus.js? (Yes/No)"
        read vivusJs
        if isYes $vivusJs ; then
            scriptNames[${#scriptNames[@]}]='vivus'
            scripts[${#scripts[@]}]='//cdnjs.cloudflare.com/ajax/libs/vivus/0.4.5/vivus.min.js'
        fi
        
        echo "Add Svg Support? (Yes/No)"
        read svgSupport
        if isYes $svgSupport ; then        
            otherFunctions[${#otherFunctions[@]}]='\n// allow uploading svgs\nfunction cc_mime_types($mimes)\n{\n    $mimes["svg"] = "image/svg+xml";\n\n   return $mimes;\n}\nadd_filter("upload_mimes", "cc_mime_types");\n'
        fi
        
    fi

    # # Styles
    echo -e "<?php\n\n// load the theme css\nadd_action('wp_enqueue_scripts', 'theme_styles');\nfunction theme_styles()\n{\n" >> $functionsFilePath
    for i in "${!styles[@]}"; do
        echo -e "      wp_enqueue_style('${styleNames[$i]}', ${styles[$i]}, '1.9');\n" >> $functionsFilePath
    done
    echo -e "}\n\n" >> $functionsFilePath
    # # Scripts
    echo -e "\n\n// load the theme css\nadd_action('wp_enqueue_scripts', 'theme_js');\nfunction theme_js()\n{\n" >> $functionsFilePath
    for i in ${!scripts[@]}; do
        echo  -e "      wp_register_script('${scriptNames[$i]}',  ${scripts[$i]}, '1.9');\n" >> $functionsFilePath
    done
    for (( idx=${#scripts[@]}-1 ; idx>=0 ; idx-- )) ; do
        echo -e "      wp_enqueue_script('${scriptNames[$idx]}');" >> $functionsFilePath
    done
    
    echo -e "}\n\n" >> $functionsFilePath

    # # Other Functions
    echo -e "// hide admin bar on front\nshow_admin_bar(false);\n\n// disable gutenberg\nadd_filter('use_block_editor_for_post', '__return_false');\n\n// Adding thumbnail support\nadd_theme_support('post-thumbnails');\n\n" >> $functionsFilePath
    echo -e "// Register ACF\ninclude 'includes/acf-register.php';\n// Register CPT\ninclude 'includes/cpt-register.php';\n" >> $functionsFilePath
    echo -e "\n\n${otherFunctions}" >> $functionsFilePath
    
}

initializePluginDialog(){
    # Script for changing plugin name files
    $ find . -iname "*plugin-name*" -exec rename 's/plugin-name/pipedrive-users/' '{}' \;
}

oldOrNewThemeDialog(){
    echo "Are You Building It from Scratch"
    options=("Yep" "Nope")
    select opt in "${options[@]}"
    do
        case $opt in
            "Yep")
                initializeThemeDialog
                git init
                break
            ;;
            "Nope")
                gettingRepoDialog
                break
            ;;
            *) echo "invalid option $REPLY";;
        esac
    done
}

getDefualtValues
buildingDialog
taskReplace
initializingEnv
envReplace $ACF_PRO_KEY

if [[ ${Building} == "theme" ]];then
    oldOrNewThemeDialog
else
    echo "Does not support $Building yet" 
fi