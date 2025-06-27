# 🔁 Conversor de Fortran a Python (Fortran2Python)

Este proyecto implementa un conversor semiautomático que traduce código fuente en un subconjunto de **Fortran 90** a su equivalente en **Python**. Está diseñado como una herramienta educativa y de apoyo para programadores que desean migrar o entender código antiguo escrito en Fortran.

---

## 🌟 Objetivos del Proyecto

- ✅ Facilitar la migración de programas Fortran hacia Python.
- ✅ Promover el entendimiento de técnicas de compiladores (análisis léxico y sintáctico).
- ✅ Brindar ejemplos prácticos de uso de Flex y Bison.
- ✅ Automatizar tareas repetitivas en conversión de código legacy.

---

## 🛠 Tecnologías y herramientas usadas

| Tecnología | Propósito |
|------------|-----------|
| **Flex**   | Generar el analizador léxico (scanner). |
| **Bison**  | Construir el parser y realizar acciones semánticas. |
| **C**      | Integración de componentes, entrada/salida, funciones auxiliares. |
| **Cygwin** | Entorno POSIX sobre Windows para usar herramientas tipo Unix. |

---

## 📦 Estructura del Repositorio
fypp/
├── lexer.l # Reglas léxicas con Flex
├── parser.y # Reglas sintácticas con Bison
├── main.c # Lógica principal del compilador
├── build.sh # Script automatizado para compilar
├── fortran2python # Ejecutable generado (tras build)
├── ejemplos/ # +100 archivos Fortran con ejercicios reales
├── salida.py # Código Python generado (salida)
├── README.md # Este archivo


---

## 🚀 Instalación y ejecución

### 🔧 Requisitos previos

- Linux o Windows con **Cygwin**
- `gcc`, `flex`, `bison` instalados

### 🔨 Compilación

```bash
./build.sh

Esto genera el ejecutable fortran2python.

▶️ Uso
bash
Copiar
Editar
./fortran2python ejemplos/ejercicio1.f90 salida.py
Si no se especifica salida.py, el programa te pedirá el nombre por consola.

🧠 Características soportadas
✅ Sintaxis de Fortran soportada:
Asignaciones: x = 10

Condicionales: if cond then ... else ... end

Bucles:

for i = 1 to 10 step 1 ... end

while cond ... end

Expresiones: suma, resta, multiplicación, división

Funciones matemáticas: exp(a, b) → a ** b

Impresión: print "mensaje"

Comentarios:

Fortran: ! este es un comentario

Traducido a Python: # este es un comentario

💡 Ejemplo de entrada y salida
Código Fortran (ejemplo.f90):
fortran
Copiar
Editar
! Suma acumulativa con impresión
x = 0
for i = 1 to 5 step 1
    x = x + i
end
print x
Código generado en Python:
python
Copiar
Editar
# Suma acumulativa con impresión
x = 0
for i in range(1, 5 + 1, 1):
    x = x + i
print(x)
🧪 Ejercicios incluidos
En la carpeta ejemplos/ se incluyen más de 100 programas Fortran, con temas como:

Algoritmos matemáticos

Geometría y trigonometría

Factoriales, series, sumatorias

Números primos, mcm, mcd

Uso de exp, for, if, while, print

Simulaciones simples

Programas tipo calculadora

Estos fueron seleccionados para probar diferentes estructuras de control y expresiones.

🔍 Detalles técnicos
parser.y define la gramática y contiene el código C que genera la salida en Python.

lexer.l reconoce tokens de palabras clave, operadores, números, strings y comentarios.

El código generado se escribe en un archivo .py limpio, indentado, y legible.

Los comentarios ! texto de Fortran se convierten automáticamente a # texto.

🧩 Posibles mejoras futuras
Soporte para subroutines, functions, y arrays

Traducción de tipos (integer, real) a variables Python

Optimización de expresiones matemáticas complejas

Detección de errores léxicos/sintácticos más robusta

Interfaz gráfica o web para arrastrar y convertir archivos

❓ FAQ
¿Traduce todo Fortran?
No. Está enfocado en estructuras básicas de control y operaciones numéricas.

¿Traduce comentarios?
Sí, los comentarios con ! se convierten a #.

¿Funciona con archivos .f y .f90?
Sí, ambos.

¿Necesito Python instalado para ejecutar los archivos generados?
Sí. Se recomienda Python 3.6+.

👨‍💻 Autor
Desarrollado por:

Pedro Ñaupa Valeriano
Estudiante de ingeniería de sistemas
📍 Perú
🛠️ Proyecto desarrollado como parte de una práctica avanzada de compiladores


