// template_mod.cpp
#include <windows.h>
#include "mhk2api.h"

// Глобальный указатель на API модлоадера
const MHK2API* g_ModApi = nullptr;

// Пример адреса в игре, который мы хотим изменить
const DWORD TargetAddress = 0x00400000; 

extern "C" __declspec(dllexport) void InitializeMod(const MHK2API* api) {
    g_ModApi = api;
    
    // Логируем старт нашего нового мода
    g_ModApi->Log("[TemplateMod] Инициализация пустого шаблона...");

    // Читаем какую-нибудь кастомную настройку из INI
    int myCustomSetting = g_ModApi->GetConfigInt("TemplateMod", "CustomValue", 42);
    g_ModApi->Log("[TemplateMod] Прочитано значение из конфига: %d", myCustomSetting);

    // Пример безопасного патчинга памяти (заменяем байты на NOP - 0x90)
    // Шаблон g_ModApi->Write автоматически понимает размер типа данных (в данном случае BYTE)
    // g_ModApi->Write<BYTE>((LPVOID)TargetAddress, 0x90);
    
    g_ModApi->Log("[TemplateMod] Мод успешно применил все патчи.");
}