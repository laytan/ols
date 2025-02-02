#!/usr/bin/env bash


if [[ $1 == "CI" ]]
then
	shift

    export PATH=$PATH:$PWD/Odin
    #BUG in odin test, it makes the executable with the same name as a folder and gets confused.
    cd tests

    odin test ../tests -collection:shared=../src -o:speed $@

    if ([ $? -ne 0 ])
    then
        echo "Ols tests failed"
        exit 1
    fi

    cd ..

    tools/odinfmt/tests.sh

    if ([ $? -ne 0 ])
    then
        echo "Odinfmt tests failed"
        #darwin bug in snapshot
        #exit 1
    fi
fi
if [[ $1 == "single_test" ]]
then
	shift

    #BUG in odin test, it makes the executable with the same name as a folder and gets confused.
    cd tests

    odin test ../tests -collection:shared=../src -test-name:$@

	shift

    if ([ $? -ne 0 ])
    then
        echo "Test failed"
        exit 1
    fi

	exit 0
fi

if [[ $1 == "test" ]]
then
	shift

    #BUG in odin test, it makes the executable with the same name as a folder and gets confused.
    cd tests

    odin test ../tests -collection:shared=../src $@

    if ([ $? -ne 0 ])
    then
        echo "Test failed"
        exit 1
    fi

	exit 0
fi
if [[ $1 == "debug" ]]
then
	shift

    odin build src/ -collection:shared=src -out:ols -use-separate-modules -debug $@
    exit 0
fi


odin build src/ -collection:shared=src -out:ols -o:speed $@
