#!/bin/bash

function list_users {
    echo "List of users"
    awk -F':' '{ print $1, $6 }' /etc/passwd | sort
}

#   awk: это утилита для обработки текстовых данных.
#   -F':': устанавливает символ : в качестве разделителя полей. В файле /etc/passwd каждый пользователь представлен строкой, где данные разделены двоеточиями.
#   '{ print $1, $6 }': команда awk, которая выводит первое ($1) и шестое ($6) поля для каждой строки:
#       $1 — это имя пользователя.
#       $6 — это домашний каталог пользователя.

function list_processes {
    echo "List of processes"
    ps -eo pid,comm --sort=pid
}

#    ps: команда для отображения информации о текущих процессах.
#   -e: этот параметр говорит команде ps, что нужно отобразить все процессы, запущенные в системе, а не только процессы текущего пользователя.
#   -o: указывает формат вывода. В данном случае, указываются поля, которые будут выводиться.
#    pid: идентификатор процесса (Process ID).
#    comm: имя команды или процесса.
#    --sort=pid: сортирует вывод по идентификатору процесса (PID) в порядке возрастания.

# функция для вывода подсказок (справки) о командах
function show_help {
    echo "Uasge: $0 [options]"
    echo "Options:"
    echo "  -u, --users           List users and their home directories"
    echo "  -p, --processes       List running processes"
    echo "  -h, --help            Show this help message"
    echo "  -l PATH, --log PATH   Redirect output to a file at PATH"
    echo "  -e PATH, --errors PATH Redirect error output to a file at PATH"
}

if [ "$#" -eq 0 ]; then
    echo "Usage: $0 [-u|--users] [-p|--processes]"
    exit 1
fi 

#   "$#" — это специальная переменная в Bash, которая содержит количество аргументов, переданных скрипту.
#   Если аргументы не были переданы, скрипт завершает свою работу с кодом выхода 1, что означает, что завершение произошло из-за ошибки или неправильного использования.

# getopts анализирует (парсит) опции и аргументы команд, которые были переданы
# двоеточия типа делят. чтобы не только 'L', а например 'OL'. В обычном случае он будет их по отдельности смотреть
while getopts ":uphl:e:-:" opt; do
    case $opt in
        u)
            action="users"
            ;;
        p)
            action="processes"
            ;;
        h)
            show_help
            exit 0
            ;;
        # я крч в инете так нашел. наверное можно было как-то иначе, но вроде работает и ладно.
        -)
            case "${$OPTARG}" in
            users)
                action="users"
                ;;
            processes)
                action="processes"
                ;;
            help)
                show_help
                exit 0
                ;;
             *)
                echo "Error: --${OPTARG}" >&2
                exit 1
                ;;
            esac
            ;;
        \?)
            echo "Error: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "////"
            exit 1
            ;;
    esac
done

# типа после присвоения 'action' какого-то параметра, можно что-то делать
case $action in
    users)
        list_users
        ;;
    processes)
        list_processes
        ;;
    *)
    echo "Error" >&2
    show_help
    exit 1
    ;;
esac
