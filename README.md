# Instagram LiquidGlass Hook

Tweak compatível com Substrate/MobileSubstrate que habilita recursos LiquidGlass do Instagram (TabBar flutuante, dynamic sizing, blur escuro) via hooks runtime no FBSharedFramework.framework.

## Visão Geral

O tweak replica os patches manuais da V2, interceptando funções de feature flags e forçando retorno sempre `true` (1) usando stubs ARM64. Compatível com iOS 16.0+ (arm64/arm64e).

### Mudanças na V2
- Reforçou todos os gates centrais de LiquidGlass/TabBar.
- Adicionou `_IGDSAlwaysDarkBlurBackground` para blur escuro consistente.

## Requisitos
- Dispositivo jailbroken com Substrate/MobileSubstrate.
- Theos instalado (opcional para build local).
- Xcode Command Line Tools (para macOS).

## Instalação e Uso

### Build Local (opcional)
1. Clone o repo.
2. Instale Theos: `git clone https://github.com/theos/theos.git $THEOS`.
3. `make package` para gerar .deb.
4. Instale via `dpkg -i` ou Cydia.

### Download Automático
Baixe a dylib mais recente dos releases do GitHub Actions: `InstagramLiquidGlassHook.dylib`.

## Integração na IPA do Instagram

### Método 1: Injeção via insert_dylib (Recomendado)

1. **Extraia a IPA do Instagram:**
   ```bash
   unzip Instagram.ipa -d extracted/
   ```

2. **Crie o diretório Frameworks (se não existir):**
   ```bash
   mkdir -p extracted/Payload/Instagram.app/Frameworks/
   ```

3. **Copie a dylib para Frameworks:**
   ```bash
   cp InstagramLiquidGlassHook.dylib extracted/Payload/Instagram.app/Frameworks/
   ```

4. **Insira a dylib no binário principal:**
   ```bash
   insert_dylib --inplace --all-yes \
     @executable_path/Frameworks/InstagramLiquidGlassHook.dylib \
     extracted/Payload/Instagram.app/Instagram
   ```

   **Nota:** A dylib já está configurada com `install_name = @executable_path/Frameworks/InstagramLiquidGlassHook.dylib`, então o `LC_LOAD_DYLIB` será criado corretamente.

5. **Reassine a IPA:**
   ```bash
   # Com ldid (jailbreak)
   ldid -S extracted/Payload/Instagram.app/Instagram
   ldid -S extracted/Payload/Instagram.app/Frameworks/InstagramLiquidGlassHook.dylib
   
   # Ou com codesign (desenvolvimento)
   codesign --force --sign "Apple Development" \
     --entitlements entitlements.xml \
     extracted/Payload/Instagram.app/Instagram
   codesign --force --sign "Apple Development" \
     extracted/Payload/Instagram.app/Frameworks/InstagramLiquidGlassHook.dylib
   ```

6. **Recompacte a IPA:**
   ```bash
   cd extracted/
   zip -r ../Instagram-patched.ipa Payload/
   ```

### Método 2: Verificação do install_name

Para verificar se o `install_name` está correto:

```bash
otool -L InstagramLiquidGlassHook.dylib | head -2
```

Deve mostrar:
```
InstagramLiquidGlassHook.dylib:
	@executable_path/Frameworks/InstagramLiquidGlassHook.dylib (compatibility version 0.0.0, current version 0.0.0)
```

## Teste
- Verifique TabBar flutuante/dynamic/blur no Instagram.
- Habilite listener de debug para logs no console.

## Troubleshooting
- Se crashes, verifique símbolos com `nm` ou class-dump no FBSharedFramework original.
- Para novas versões do Instagram, atualize endereços no `symbols.json` e recrie.
- Use issue template para reportar shifts de símbolos.

## Licença
MIT. Use por sua conta e risco (pode violar ToS do Instagram).

