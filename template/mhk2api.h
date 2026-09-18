// mhk2api.h
#pragma once
#include <windows.h>

struct MHK2API {
    int Version;

    // 1. ЛОГИРОВАНИЕ
    // Функция форматированного вывода (аналог printf для модов)
    void (*Log)(const char* format, ...);

    // 2. РАБОТА С КОНФИГУРАЦИЕЙ (INI)
    // Чтение строки, целого числа и запись строки в mhk2mods.ini
    DWORD (*GetConfigString)(const char* section, const char* key, const char* defaultValue, char* outBuffer, DWORD bufferSize);
    int   (*GetConfigInt)(const char* section, const char* key, int defaultValue);
    BOOL  (*WriteConfigString)(const char* section, const char* key, const char* value);

    // 3. БЕЗОПАСНАЯ РАБОТА С ОЗУ
    // Запись произвольного массива байт
    BOOL (*WriteMemory)(void* address, const void* data, size_t size);
    // Чтение произвольного массива байт
    BOOL (*ReadMemory)(const void* address, void* outData, size_t size);
    
    // Вспомогательные шаблоны для чтения/записи единичных значений (int, float, DWORD)
    // Они будут работать автоматически во всех модах, использующих этот заголовочный файл
    template <typename T>
    BOOL Write(void* address, T value) {
        return WriteMemory(address, &value, sizeof(T));
    }

    template <typename T>
    T Read(const void* address, T defaultValue = T()) {
        T val;
        if (ReadMemory(address, &val, sizeof(T))) {
            return val;
        }
        return defaultValue;
    }
};

// Точка входа для модов
typedef void(*ModInit_t)(const MHK2API* api);
