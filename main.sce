//Trabalho Final da Disciplina Cálculo Numérico

//Variáveis do Problema

D1 = 0.2//Diâmetro na extremidade fixa, quando x = 1, D = ao mesmo valor
D2 = 0.15//Diâmetro na outra extremidade, vamos alterar para os outros valores especificados no trabalho
L = 2.5//Comprimento da Haste
E = 208*(10^9) //Módulo da elasticidade

//Solução

//Criando uma função com os valores do diâmetro para cada valor de D2

function Diametro = D(x)
    Diametro = D1 + x*(D2 - D1)/L;
endfunction

//Cálculo dos momentos de inercia para cada D2 do problema
function Inercia = I(x)
    Inercia = (%pi*(D(x))^4)/64;
endfunction

//Declarando as funções do problema
function deflexao = y(x)
    deflexao = (1 - cos((%pi*x)/2*L));
endfunction

function der_deflexao = dy(x)
    der_deflexao = (%pi/2*L)*sin((%pi*x)/2*L);
endfunction

function der2_deflexao = d2y(x)
    der2_deflexao = ((%pi^2)/(4*L^2))*cos((%pi*x)/2*L);
endfunction

//Preparando as funções que serão integradas

function energia_armazenada = Ea(x)
    energia_armazenada = (I(d2y(x)))^2;
endfunction

function trabalho = W(x)
    trabalho = (dy(x))^2;
endfunction

//Cálculo da Integral pelo método dos trapézios compostos

function Int = integral_trapezios_ea(a, b, n)//a é o limite inferior, b o superior e n é o número de iterações
    h = (b - a)/n;
    xi = a + h;    
    soma = 0;    
    for i=1:n-1
        soma = soma + Ea(xi);
        xi = xi + h;
    end    
    Int = (h/2)*(Ea(a)+Ea(b)) + h*soma;    
endfunction

function Int = integral_trapezios_w(a, b, n)//a é o limite inferior, b o superior e n é o número de iterações
    h = (b - a)/n;
    xi = a + h;
    
    soma = 0;
    
    for i=1:n-1
        soma = soma + W(xi);
        xi = xi + h;
    end
    
    Int = (h/2)*(W(a)+W(b)) + h*soma;    
endfunction


vetor_N = [1:15];//Abssica no gŕafico para a análise de erro

//Cálculo da carga crítica pelo método dos trapézios
function f = F_trap(n)//Parâmetro é o numero de iterações para traçar o gráfico de erros
    f = (E*integral_trapezios_ea(0, L, n))/integral_trapezios_w(0, L, n)
endfunction

//Para traçar o gráfico vamos criar um vetor de mesma dimensão de vetor_N onde os elementos são as cargas críticas



F = zeros(1,15);


cont = 1;

while(cont <= 15)
    F(cont) = F_trap(cont);
    cont = cont + 1; 
end

scf()//Abre gráfico 
xtitle('Método dos Trapézios: Carga Crítica x Número de áreas calculadas', 'n', 'F(N)');
plot(vetor_N, F, 'k.');

disp(F, 'Cargas críticas pelo método dos trapézios c/ n de 1:15')

//Aqui vamos analisar o erro pelo método dos trapézios
function E = erro_trap(a, b, n)
    E = ((((b - a)^3)/(12*n^2))*d2y((b-a)/2))*100;
endfunction

Erro = zeros(1,15);

cont = 1;

while(cont <= 15)
    Erro(cont) = erro_trap(0, L, cont);
    cont = cont + 1; 
end

scf()//Abre gráfico 
xtitle('Método dos Trapézios: Erro x Número de áreas calculadas', 'n', 'E(%)');
plot(vetor_N, Erro);

disp(Erro, 'Erros % pelo método dos trapézios c/ n de 1:15')

//Começando análise pelo método 1/3 Simpson

function Int = integral_simpson_ea(a, b, n)
    h = (b - a)/n;
    soma1 = 0;
    soma2 = 0;
    
    xi = a + h;
    for i = 1: n-1
        if (modulo(i,2) ~= 0) then
            soma1 = soma1 + Ea(xi);
            xi = xi + h;        
        else
            soma2 = soma2 + Ea(xi);
            xi = xi + h;
        end
      
    end
    
   Int = (h/3) * (Ea(a)+4*soma1+2*soma2+Ea(b));
endfunction

function Int = integral_simpson_w(a, b, n)
    h = (b - a)/n;
    soma1 = 0;
    soma2 = 0;    
    xi = a + h;
    for i = 1: n-1
        if (modulo(i,2) ~= 0) then
            soma1 = soma1 + W(xi);
            xi = xi + h;        
        else
            soma2 = soma2 + W(xi);
            xi = xi + h;
        end      
    end    
   Int = (h/3) * (W(a)+4*soma1+2*soma2+W(b));
endfunction

//Carga Crítica em Função do núemro de iterações no método de Simpson
function f = F_simpson(n)//Parâmetro é o numero de iterações para traçar o gráfico de erros
    f = (E*integral_simpson_ea(0, L, n))/integral_simpson_w(0, L, n)
endfunction


//Repetindo o procedimento anterior para o método Simpson
F = zeros(1,15);

cont = 1;

while(cont <= 15)
    F(cont) = F_simpson(cont);
    cont = cont + 1; 
end

scf()//Abre gráfico 
xtitle('Método 1/3 Simpson: Carga Crítica x Número de áreas calculadas', 'n', 'F(N)');
plot(vetor_N, F, 'k.');

disp(F, 'Cargas críticas pelo método Simpson c/ n de 1:15');//Vetor com valores calculados pelo método


//Aqui vamos analisar o erro pelo método Simpson
function E = erro_simp(a, b, n)
    E = ((((b - a)^5)/(2880*n^4))*(y((b-a)/2))^4)*100;
endfunction

Erro = zeros(1,15);

cont = 1;

while(cont <= 15)
    Erro(cont) = erro_simp(0, L, cont);
    cont = cont + 1; 
end

scf()//Abre gráfico 
xtitle('Método 1/3 Simpson: Erro x Número de áreas calculadas', 'n', 'E(%)');
plot(vetor_N, Erro, 'r');

disp(Erro, 'Erros % pelo método 1/3 Simpson c/ n de 1:15')
