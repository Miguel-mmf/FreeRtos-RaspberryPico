# FreeRtos + Raspberry Pico - Um Guia de Utilização em [pt-br]
Esse repositório é dedicado a compilação de ferramentas que auxiliem no compreendimento básico e na instalação do sistema FreeRtos na Raspberry Pico a partir de uma máquina Linux. Assim, serão sempre apresentadas as referências que embasam esse guia de utilização. É importante destacar também que o intuito desse material é não comercial e visa simplesmente a difusão de conhecimento.

## Tutorial 1: Instalação e Compilação do Primeiro Programa utilizando o SDK
Instalando o SDK (Software Development Kit). Nesse sentido, pode-se pensar no SDK como um conjunto de ferramentas e recursos que se utiliza para trabalhar em uma plataforma específica. Para proceder com a instalação, deve-se clonar o repositório do sdk e proceder com a instalação (ao final de cada seçao é deixada um .sh que executa toda a sequência de comandos apresentada).

Criando um diretório para se trabalhar:
'''sh
cd ~/
mkdir pico
cd pico
'''

Clonando o sdk e os exemplos para a rasberry pico (do repositório oficial). Nesse caso, foi feita uma adaptação para que apenas o úlimo deploy via git seja coletado com o parâmetro --depth 1.
''' sh
git clone https://github.com/raspberrypi/pico-sdk.git --branch master --depth 1
cd pico-sdk
git submodule update --init
cd ..
git clone https://github.com/raspberrypi/pico-examples.git --branch master --depth 1
'''

De como a compilar os exemplos disponibilziados pelo time da rasberry, faz-se necessária a instalção de algumas bibliotecas para a compilação dos scripts.
''' sh
sudo apt update
sudo apt install cmake gcc-arm-none-eabi libnewlib-arm-none-eabi build-essential
'''

Por fim, pode-se atualizar a versão do SDK de modo a utilizar-se a versão mais recente disponível a partir dos arquivos clonados do repositório.
'''sh
cd pico-sdk
git pull
git submodule update
'''

Por fim, vamos finalmente piscar o led ;) Assim, vale destacar que os arquivos da Raspberry pico são compilados via CMake que basicamente são abastrações de makefiles, de modo a deixar o processo de compilação mais fácil. Se faz sempre necessária a criação de uma pasta **build**, fique atento porque isso é um procedimento padrão. Por fim, deve-se observar o arquivo sdk na hora de compilar, conforme será mostrado no código abaixo.
'''
cd pico-examples
mkdir build
cd build
'''

'''sh
cmake PICO_SDK_PATH=~/pico/pico-sdk
cd blink
make -j4
'''

E pronto, no código acima compilamos o exemplo de *blink* (piscar) um LED, nesse caso se atente a notação do ckame em que a pasta contendo o sdk é passado, já que no exemplo do kernel esse processo ficará consideravelmente mais complexo. ALém disso, a notação *make -j4* diz respeito que a compilação dos programas utilzizará 4 workers, eu recomendo que esse número seja ajustado para 2x o seu número de núcleos de processador.

Se atente que o arquivo gerado foram: *blink.elf* (utilizado para debugação) e o *blink.uf2*, este último que deve ser arrastado para a rasberry que com a ajuda do SDK deve aparecer como um dispositivo de Pendrive bastando-se apenas colocar o arquivo blink.uf2 dentro dele que ele irá reiniciar automaticamente e iniciar as instruções. É interessante notar que esse exemplo ainda não roda o FreeRtos propriamente dito. Caso você esteja em ambiente não gráfico pode-se montar a comunicação a partir de um MSB, essa etapa é melhor descrita na própria documentação disposta abaixo.

O Script contendo toda a sequência de comandos para facilitar a operação está disponibilizado em: 

Referência: https://datasheets.raspberrypi.com/pico/getting-started-with-pico.pdf

## Tutorial 2: Instalação e Compilação do Primeiro Programa utilizando o Kernel do FreeRtos

