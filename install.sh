#!/usr/bin/env bash

DOWNLOAD_DIR=${1:-$HOME/Downloads}
ROOT=${2:-$HOME}
TOOLS_DIR=${ROOT}/Tools

echo Downloads: ${DOWNLOAD_DIR}
echo Output: ${TOOLS_DIR}

function download() {
    if [ ! -f ${DOWNLOAD_DIR}/$1 ]
    then
        echo "Downloading $1..."
        wget -q --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" -O ${DOWNLOAD_DIR}/$1 $2
        echo "$1 download completed"
    else
        echo "$1 already exists"
    fi
    if [ -n "$3" ]
    then
        echo "Extracting $1 to $3 ..."
        mkdir -p $3
        if [[ "$1" == *gz ]]; then
            tar -zxvf ${DOWNLOAD_DIR}/$1 -C $3
        fi
        if [[ "$1" == *zip ]]; then
            unzip ${DOWNLOAD_DIR}/$1 -d $3
        fi
        if [[ "$1" == *bin ]]; then
            chmod +x ${DOWNLOAD_DIR}/$1
            (cd $3 && ${DOWNLOAD_DIR}/$1)
        fi
    fi
}

function check_md5() {
    md5=($(md5sum files/$1))
    if [ "$md5" != "$2" ]
    then
        echo "Incorrect jdk md5sum for $1";
        exit -1;
    fi
}

mkdir -p ${DOWNLOAD_DIR}

download 'jdk-6u45-linux-i586.bin'              "http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-linux-i586.bin"      ${TOOLS_DIR}/java/i586
download 'jdk-6u45-linux-x64.bin'               "http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-linux-x64.bin"       ${TOOLS_DIR}/java/x64

download 'jdk-7u80-linux-i586.tar.gz'           "http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-linux-i586.tar.gz"   ${TOOLS_DIR}/java/i586
download 'jdk-7u80-linux-x64.tar.gz'            "http://download.oracle.com/otn-pub/java/jdk/7u80-b15/jdk-7u80-linux-x64.tar.gz"    ${TOOLS_DIR}/java/x64

download 'jdk-8u66-linux-i586.tar.gz'           "http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jdk-8u66-linux-i586.tar.gz"   ${TOOLS_DIR}/java/i586
download 'jdk-8u66-linux-x64.tar.gz'            "http://download.oracle.com/otn-pub/java/jdk/8u66-b17/jdk-8u66-linux-x64.tar.gz"    ${TOOLS_DIR}/java/x64

download 'apache-groovy-binary-2.4.5.zip'       'http://dl.bintray.com/groovy/maven/apache-groovy-binary-2.4.5.zip'                 ${TOOLS_DIR}/groovy

download 'apache-maven-2.2.1-bin.tar.gz'        'http://archive.apache.org/dist/maven/maven-2/2.2.1/binaries/apache-maven-2.2.1-bin.tar.gz' ${TOOLS_DIR}/maven
download 'apache-maven-3.3.9-bin.tar.gz'        'http://archive.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz' ${TOOLS_DIR}/maven

download 'gradle-2.8-all.zip'                   'https://services.gradle.org/distributions/gradle-2.8-all.zip'                              ${TOOLS_DIR}/gradle

download 'apache-ant-1.9.6-bin.tar.gz'          'http://ftp.ps.pl/pub/apache/ant/binaries/apache-ant-1.9.6-bin.tar.gz'                      ${TOOLS_DIR}/ant

download 'apache-tomcat-6.0.44.tar.gz'          'http://ftp.ps.pl/pub/apache/tomcat/tomcat-6/v6.0.44/bin/apache-tomcat-6.0.44.tar.gz'       ${TOOLS_DIR}/tomcat
download 'apache-tomcat-7.0.65.tar.gz'          'http://ftp.ps.pl/pub/apache/tomcat/tomcat-7/v7.0.65/bin/apache-tomcat-7.0.65.tar.gz'       ${TOOLS_DIR}/tomcat
download 'apache-tomcat-8.0.28.tar.gz'          'http://ftp.ps.pl/pub/apache/tomcat/tomcat-8/v8.0.28/bin/apache-tomcat-8.0.28.tar.gz'       ${TOOLS_DIR}/tomcat
download 'apache-tomcat-9.0.0.M1.tar.gz'        'http://ftp.ps.pl/pub/apache/tomcat/tomcat-9/v9.0.0.M1/bin/apache-tomcat-9.0.0.M1.tar.gz'   ${TOOLS_DIR}/tomcat

download 'ideaIU-15.0.1.tar.gz'                 'http://download.jetbrains.com/idea/ideaIU-15.0.1.tar.gz'                                   ${TOOLS_DIR}/idea

download 'SoapUI-5.2.1-linux-bin.tar.gz'        'http://cdn01.downloads.smartbear.com/soapui/5.2.1/SoapUI-5.2.1-linux-bin.tar.gz'           ${TOOLS_DIR}/soapui
download 'apache-jmeter-2.13.tgz'               'http://ftp.ps.pl/pub/apache//jmeter/binaries/apache-jmeter-2.13.tgz'                       ${TOOLS_DIR}/jmeter

download 'scala-2.11.7.tgz'                     'http://downloads.typesafe.com/scala/2.11.7/scala-2.11.7.tgz'                               ${TOOLS_DIR}/scala
download 'sbt-0.13.9.tgz'                       'https://dl.bintray.com/sbt/native-packages/sbt/0.13.9/sbt-0.13.9.tgz'                      ${TOOLS_DIR}/scala

download 'install4j_unix_6_0_4.tar.gz'          'http://download-aws.ej-technologies.com/install4j/install4j_unix_6_0_4.tar.gz'             ${TOOLS_DIR}

download 'sqldeveloper-4.1.2.20.64-no-jre.zip'  'http://download.oracle.com/otn/java/sqldeveloper/sqldeveloper-4.1.2.20.64-no-jre.zip'      ${TOOLS_DIR}

cat << EOF >> ${ROOT}/.environment
#!/bin/bash
export TOOLS_HOME=\$HOME/Tools
export PS1="\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\n$"

# IntelliJ IDEA
export IDEA_HOME=\$TOOLS_HOME/idea/idea-IU-143.382.35
export PATH=\$IDEA_HOME/bin:\$PATH

# java 1.6
export JAVA6_HOME=\$TOOLS_HOME/java/i586/jdk1.6.0_45
export JAVA6_64_HOME=\$TOOLS_HOME/java/x64/jdk1.6.0_45

# java 1.7
export JAVA7_HOME=\$TOOLS_HOME/java/i586/jdk1.7.0_80
export JAVA7_64_HOME=\$TOOLS_HOME/java/x64/jdk1.7.0_80

# java 1.8
export JAVA8_HOME=\$TOOLS_HOME/java/i586/jdk1.8.0_66
export JAVA8_64_HOME=\$TOOLS_HOME/java/x64/jdk1.8.0_66

# Use Java 1.8 by default
export JAVA_HOME=\$JAVA8_64_HOME
export PATH=\$JAVA_HOME/bin:\$PATH

# maven
export MAVEN_OPTS="-Xms512M -Xmx1024M -XX:MaxPermSize=300M"
export MAVEN3_HOME=\$TOOLS_HOME/maven/apache-maven-3.3.9
export MAVEN2_HOME=\$TOOLS_HOME/maven/apache-maven-2.2.1

# Use Maven 3 by default
export M2_HOME=\$MAVEN3_HOME
export MAVEN_HOME=\$M2_HOME
export PATH=\$M2_HOME/bin:\$PATH

# ant
export ANT_HOME=\$TOOLS_HOME/ant/apache-ant-1.9.6
export ANT_OPTS="-Xms256M -Xmx1024M -XX:MaxPermSize=128M"
export PATH=\$ANT_HOME/bin:\$PATH

# gradle
export GRADLE_HOME=\$TOOLS_HOME/gradle/gradle-2.9
export PATH=\$GRADLE_HOME/bin:\$PATH

# Scala
export SCALA_HOME=\$TOOLS_HOME/scala/scala-2.11.7
export SBT_HOME=\$TOOLS_HOME/scala/sbt
export PATH=\$SCALA_HOME/bin:\$SBT_HOME/bin:\$PATH

# install4j
export INSTALL4J_HOME=\$TOOLS_HOME/install4j6

# jmeter
export JMETER_HOME=\$TOOLS_HOME/jmeter/apache-jmeter-2.13

#SOAPUI
export SOAPUI_HOME=\$TOOLS_HOME/soapui/SoapUI-5.2.1

EOF

PROFILE_FILE=~/.bash_profile

cat << EOF >> ${ROOT}/.bashrc
if [ -f ${PROFILE_FILE} ]; then
    . ${PROFILE_FILE}
fi

if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi
EOF

cat << EOF >> ${HOME}/.bash_profile
if [ -f "\$HOME/.environment" ]; then
    . "\$HOME/.environment"
fi

if [ -d "\$HOME/bin" ] ; then
  PATH="\$HOME/bin:\$PATH"
fi
EOF

cat << EOF > ${HOME}/.bash_functions
#!/bin/bash

# maven
function m3()
{
    export M2_HOME=\$MAVEN3_HOME
    export MAVEN_HOME=\$M2_HOME
    export PATH=\$M2_HOME/bin:\$PATH
}

function m2()
{
    export M2_HOME=\$MAVEN2_HOME
    export MAVEN_HOME=\$M2_HOME
    export PATH=\$M2_HOME/bin:\$PATH
}

# java
function use_java()
{
    export JAVA_HOME=\$1
    export PATH=\$JAVA_HOME/bin:\$PATH
    java -version
}

function j6()
{
    use_java \$JAVA6_HOME
}
function j6_64()
{
    use_java \$JAVA6_64_HOME
}

function j7()
{
    use_java \$JAVA7_HOME
}

function j7_64()
{
    use_java \$JAVA7_64_HOME
}

function j8()
{
    use_java \$JAVA8_HOME
}

function j8_64()
{
    use_java \$JAVA8_64_HOME
}

EOF

mkdir -p ${ROOT}/bin

cat << EOF >> ${ROOT}/bin/start-idea.sh
#!/bin/bash
PATH=\$PATH:/usr/bin

. ${PROFILE_FILE}

j8_64

idea.sh
EOF

cat << EOF >> ${ROOT}/bin/start-soapui.sh
#!/bin/bash
PATH=\$PATH:/usr/bin

. ${PROFILE_FILE}

j8_64

cd \$SOAPUI_HOME/bin && ./soapui.sh

EOF

cat << EOF >> ${ROOT}/bin/start-jmeter.sh
#!/bin/bash
PATH=\$PATH:/usr/bin

. ${PROFILE_FILE}

j8_64

cd \$JMETER_HOME/bin && jmeter.sh
EOF

cat << EOF >> ${ROOT}/bin/start-install4j.sh
#!/bin/sh
PATH=\$PATH:/usr/bin

. ${PROFILE_FILE}

j8_64

cd \$INSTALL4J_HOME/bin && install4j
EOF

cat << EOF >> ${ROOT}/bin/start-sqldeveloper.sh
#!/bin/sh
PATH=\$PATH:/usr/bin

. ${PROFILE_FILE}

cd ~/Tools/sqldeveloper && ./sqldeveloper.sh

EOF

chmod +x bin/*.sh

mkdir ~/Projects/
