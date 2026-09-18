@echo off
chcp 65001 >nul
title MHK2 Mod Compiler SDK

:: ==========================================
:: НАСТРОЙКИ МОДМЕЙКЕРА
:: ==========================================
:: Укажите имя вашего исходного файла (без .cpp)
set "MOD_NAME=template_mod"

:: Укажите путь к корневой папке игры (если хотите автоматическое копирование)
:: Оставьте пустым "", если хотите просто забирать готовый файл из папки SDK
set "GAME_PATH=C:\Program Files (x86)\Moorhuhn X XXL"
:: ==========================================


:: ==========================================
:: СИСТЕМНЫЕ НАСТРОЙКИ (КОМПИЛЯТОР MSVC)
:: ==========================================
set "MSVC_BIN=C:\Program Files\Microsoft Visual Studio\18\Community\VC\Tools\MSVC\14.39.33519\bin\Hostx86\x86"
set "MSVC_INC=C:\Program Files\Microsoft Visual Studio\18\Community\VC\Tools\MSVC\14.39.33519\include"
set "MSVC_LIB=C:\Program Files\Microsoft Visual Studio\18\Community\VC\Tools\MSVC\14.39.33519\lib\x86"
set "SDK_INC_BASE=C:\Program Files (x86)\Windows Kits\10\Include\10.0.22621.0"
set "SDK_LIB_BASE=C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22621.0"

:: Настройка окружения компилятора
set "INCLUDE=%MSVC_INC%;%SDK_INC_BASE%\ucrt;%SDK_INC_BASE%\um;%SDK_INC_BASE%\shared"
set "LIB=%MSVC_LIB%;%SDK_LIB_BASE%\ucrt\x86;%SDK_LIB_BASE%\um\x86"
set "PATH=%MSVC_BIN%;%PATH%"

:: --- ПРОВЕРКИ ---
if not exist "%MSVC_BIN%\cl.exe" (
    echo [ОШИБКА] Компилятор cl.exe не найден! Проверьте системные пути в батнике.
    pause
    exit /b 1
)

if not exist "%MOD_NAME%.cpp" (
    echo [ОШИБКА] Не найден файл исходного кода: %MOD_NAME%.cpp
    echo Пожалуйста, проверьте переменную MOD_NAME в начале батника.
    pause
    exit /b 1
)

if not exist "mhk2api.h" (
    echo [ОШИБКА] Заголовочный файл mhk2api.h должен находиться в этой же папке!
    pause
    exit /b 1
)

:: --- СБОРКА ---
echo =======================================================
echo Сборка мода: %MOD_NAME%.dll
echo =======================================================

:: /LD - сборка DLL, /O2 - максимальная оптимизация скорости, /EHsc - обработка C++ исключений
cl.exe /LD /O2 /EHsc "%MOD_NAME%.cpp" /Fe:"%MOD_NAME%.dll" user32.lib kernel32.lib

if %errorlevel% equ 0 (
    echo.
    echo [УСПЕХ] Сборка завершена! Файл %MOD_NAME%.dll успешно создан.
    
    :: Автоматическое развертывание в папку игры, если путь указан
    if not "%GAME_PATH%"=="" (
        if exist "%GAME_PATH%" (
            echo.
            echo [ИНФО] Копирование мода в папку игры...
            if not exist "%GAME_PATH%\mhk2_mods" mkdir "%GAME_PATH%\mhk2_mods"
            copy /Y "%MOD_NAME%.dll" "%GAME_PATH%\mhk2_mods\"
            echo [УСПЕХ] Мод скопирован в: %GAME_PATH%\mhk2_mods\%MOD_NAME%.dll
        ) else (
            echo [ПРЕДУПРЕЖДЕНИЕ] Указанный GAME_PATH не существует. Копирование отменено.
        )
    )
) else (
    echo.
    echo [ОШИБКА] Сбой компиляции! Изучите ошибки cl.exe выше.
)

echo =======================================================
pause