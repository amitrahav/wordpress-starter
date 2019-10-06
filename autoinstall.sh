#!/usr/bin/env bash
if [ -z ${WPCONFIG+x} ]; then WPCONFIG=/Users/amit/.wpconfig; fi

getDefualtValues(){
    
    if [ -f "$WPCONFIG" ]; then
        source "$WPCONFIG"
    else
        echo "Please create and set your WPCONFIG file on ${WPCONFIG} or change path by WPCONFIG varible"
    fi
    
}

taskReplace() {
    local search='<themesOrPlugins>'
    if [ -z {$Building+x} ]
    then
        local replace="$Building"+"s"
    else
        local replace='themes'
    fi
    
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

gitignoreAdd(){#Params: WhatShoulIADD
    echo "\n${1}" >> .gitignore
}

initializingEnv(){
    mv .env.example .env
}

envReplace() { #Params: ACF_PRO_KEY,
    
    if [ -z {$1+x} ]
    then
        echo "Please set ACF_PRO_KEY value on your ~/.wpconfig file"
    else
        local search='youracfkeyhere'
        local replace=$WPCONFIG
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
    options=("Theme" "Plugin")
    select opt in "${options[@]}"
    do
        case $opt in
            "Theme")
                Building='theme'
                break
            ;;
            "Plugin")
                Building='plugin'
                break
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
    read THEMENAME
    taskReplaceThemeName
    if [ -z {$THEMENAME+x} ]; then; THEMENAME = "${PWD##*/}"; fi
    gitignoreAdd "!/wp-content/themes/${THEMENAME}"
    
    local dirsToCreate = ("sass","partials","assets","js","includes")
    for i in ${dirsToCreate[@]}; do
        mkdir wp-content/themes/${THEMENAME}/${dirsToCreate[$i]}
    done
    touch 'includes/acf-register.php'
    touch 'includes/cpt-register.php'
    
    
    echo "/*!\nTheme Name: ${THEMENAME}\nTheme URI:\nDescription: A custom theme for the ${THEMENAME} project\nAuthor: TheTwo LTD.\nAuthor URI: http://the-two.co\nVersion: 1.0\nTags: clean, advanced, responsive, great\n*/" > wp-content/themes/${THEMENAME}/sass/style.scss
    echo '<!DOCTYPE html>\n<html>\n\n<head>\n   <title>\n        <?php\n        wp_title('|', true, 'right');\n        bloginfo('name');\n        ?>\n    </title>\n    <meta charset="utf-8">\n    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.3, user-scalable=1">\n    <?php wp_head(); ?>\n</head>' > wp-content/themes/${THEMENAME}/header.php
    echo '<footer>\n\n\n</footer>\n<?php wp_footer(); ?>\n</body>\n\n</html>' > wp-content/themes/${THEMENAME}/footer.php
    
    echo "Wanna Talk About Auto Inserting Functions? (Yes to continue)"
    read local functions
    # Function File Addition
    local functionsFilePath = "wp-content/themes/${THEMENAME}/functions.php"
    local styles = (["main"]="get_template_directory_uri() . '/style.css'")
    local scripts = (["main"]="get_template_directory_uri() . '/js/app.js''")
    local otherFunctions = ()
    touch $functionsFilePath
    # # Any Other?
    if [ $functions -e "yes"] || [ $functions -e "Yes"] || [ $functions -e "טקד"] || [ $functions -e "כן"]; then
        echo "Add font awesome? (Yes/No)"
        read local fontAwesome
        if [ $fontAwesome -e "yes"] || [ $fontAwesome -e "Yes"] || [ $fontAwesome -e "טקד"] || [ $fontAwesome -e "כן"]; then
            styles['prefix-font-awesome'] = '//netdna.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css'
        fi
        
        echo "Add Wow.js? (Yes/No)"
        read local wowJs
        if [ $wowJs -e "yes"] || [ $wowJs -e "Yes"] || [ $wowJs -e "טקד"] || [ $wowJs -e "כן"]; then
            scripts['wowjs'] = '//cdnjs.cloudflare.com/ajax/libs/wow/1.1.2/wow.min.js'
        fi
        
        echo "Add Slick.js? (Yes/No)"
        read local slickJs
        if [ $slickJs -e "yes"] || [ $slickJs -e "Yes"] || [ $slickJs -e "טקד"] || [ $slickJs -e "כן"]; then
            scripts['slick'] = '//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js'
            styles['slickTheme']='//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css'
            styles['slick']='//cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.9.0/slick-theme.min.css'
        fi
        
        echo "Add Vivus.js? (Yes/No)"
        read local vivusJs
        if [ $vivusJs -e "yes"] || [ $vivusJs -e "Yes"] || [ $vivusJs -e "טקד"] || [ $vivusJs -e "כן"]; then
            scripts['vivus'] = '//cdnjs.cloudflare.com/ajax/libs/vivus/0.4.5/vivus.min.js'
        fi
        
        echo "Add Svg Support? (Yes/No)"
        read local svgSupport
        if [ $svgSupport -e "yes"] || [ $svgSupport -e "Yes"] || [ $svgSupport -e "טקד"] || [ $svgSupport -e "כן"]; then
            otherFunctions +=('\n// allow uploading svgs\nfunction cc_mime_types($mimes)\n{\n    $mimes["svg"] = "image/svg+xml";\n\n   return $mimes;\n}\nadd_filter("upload_mimes", "cc_mime_types");\n')
        fi
        
    fi
    # # Styles
    echo "<?php\n\n// load the theme css\nadd_action('wp_enqueue_scripts', 'theme_styles');\nfunction theme_styles()\n{\n" >> $functionsFilePath
    for i in ${styles[@]}; do
        echo "wp_enqueue_style('$i', ${styles[$i]}, '1.9');\n" >> $functionsFilePath
    done
    echo "}\n\n" >> $functionsFilePath
    # # Scripts
    echo "<?php\n\n// load the theme css\nadd_action('wp_enqueue_scripts', 'theme_styles');\nfunction theme_styles()\n{\n" >> $functionsFilePath
    for i in ${scripts[@]}; do
        echo "wp_register_script('$i',  ${scripts[$i]}, '1.9');\n" >> $functionsFilePath
    done
    for (( idx=${#scripts[@]}-1 ; idx>=0 ; idx-- )) ; do
        echo "wp_enqueue_script('$idx');" >> $functionsFilePath
    done
    
    echo "}\n\n" >> $functionsFilePath
    
    # # Other Functions
    echo "// hide admin bar on front\nshow_admin_bar(false);\n\n// disable gutenberg\nadd_filter('use_block_editor_for_post', '__return_false');\n\n// Adding thumbnail support\nadd_theme_support('post-thumbnails');/n/n" >> $functionsFilePath
    echo "// Register ACF\ninclude 'includes/acf-register.php';\n// Register CPT\n include 'includes/cpt-register.php';\n" >> $functionsFilePath
    
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

if [ "$Building" == "theme"]
then
    oldOrNewThemeDialog
elif ["$Building" == "plugin" ]
then
    
else
    buildingDialog
fi