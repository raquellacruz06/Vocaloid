/*
Para comenzar el concierto, es preferible introducir primero a los cantantes más novedosos,
 por lo que necesitamos un predicado para saber si un vocaloid es novedoso cuando saben al menos 
 2 canciones y el tiempo total que duran todas las canciones debería ser menor a 15.

De cada vocaloid (o cantante) se conoce el nombre y además la canción que sabe cantar. De cada canción se 
conoce el nombre y la cantidad de minutos de duración.
*/
%vocaloid(Nombre, cancion(NombreCancion, DuracionCancion)).

/*megurineLuka sabe cantar la canción nightFever cuya duración es de 4 min y 
también canta la canción foreverYoung que dura 5 minutos.	
hatsuneMiku sabe cantar la canción tellYourWorld que dura 4 minutos.
gumi sabe cantar foreverYoung que dura 4 min y tellYourWorld que dura 5 min
seeU sabe cantar novemberRain con una duración de 6 min y nightFever con una duración de 5 min.
kaito no sabe cantar ninguna canción.*/

%a) Base de cocnocimientos:
vocaloid(megurineLuka, cancion(nightFever, 4)).
vocaloid(megurineLuka, cancion(foreverYoung, 5)).
vocaloid(hatsuneMiku, cancion(tellYourWorld, 4)).
vocaloid(gumi, cancion(foreverYoung, 4)).
vocaloid(gumi, cancion(tellYourWorld, 5)).
vocaloid(seeU, cancion(novemberRain, 6)).
vocaloid(seeU, cancion(nightFever, 5)).
vocaloid(seeU, cancion(nightFever, 10)).
%Por universo cerrado no hace falta escribir a kaito

%Punto 1
esNovedoso(Cantante):-
    sabeAlMenosDosCanciones(Cantante),
    cumpleDuracionMenor(Cantante, 15).

sabeAlMenosDosCanciones(Cantante):-
    vocaloid(Cantante, cancion(Cancion, _)),
    vocaloid(Cantante, cancion(OtraCancion, _)),
    Cancion \= OtraCancion.

cumpleDuracionMenor(Cantante, DuracionPedida):-
    tiempoCantante(Cantante, DuracionTotal),
    DuracionTotal < DuracionPedida. 

tiempoCantante(Cantante, DuracionTotal):-
    findall(DuracionCancion, duracionCancion(Cantante, DuracionCancion), Tiempos),
    sum_list(Tiempos, DuracionTotal).

duracionCancion(Cantante, Duracion):-
    vocaloid(Cantante, cancion(_, Duracion)).


%Punto 2
cantanteAcelerado(Cantante):-
    vocaloid(Cantante, _),
    not(cancionQueDureMas(Cantante, 4)).

cancionQueDureMas(Cantante, TiempoMinimo):-
    vocaloid(Cantante, cancion(_, Duracion)),
    Duracion > TiempoMinimo.

    %not((duracionCancion(Cantante, Duracion), Duracion > 4)).



%concierto(Nombre, Pais, CantidadFama, Tipo)
%gigante(CantidadMinimaCanciones, DuracionTotalDeTodasCanciones, ).
%mediano(DuracionTotalMaximaTodasCanciones)
%pequeño(DuracionDeAlgunaCancion)

%Base de conocimientos
concierto(mikuExpo, estadosUnidos, 2000, gigante(3, 6)).
concierto(magicalMirai, japon, 30000, gigante(4, 10)).
concierto(vocalektVisions, estadosUnidos, 1000, mediano(9)).
concierto(mikuFest, argentina, 100,pequenio(5)).

%Punto 2
%puedeParticiparEn(Concierto, Vocaloid).
puedeParticiparEn(_, hatsuneMiku).

puedeParticiparEn(Concierto, Cantante):-
    concierto(Concierto, _,_, TipoConcierto),
    cumpleRequisitosConcierto(Cantante, TipoConcierto).

%%%Requisitos Concierto Gigante
cumpleRequisitosConcierto(Cantante, gigante(CantidadMinimaCanciones, MinimaDuracion)):-
    cumpleCantidadCanciones(Cantante, CantidadMinimaCanciones),
    cumpleTiempoTotal(Cantante, MinimaDuracion).

cumpleCantidadCanciones(Cantante, CantidadMinimaCanciones):-
    cantidadCanciones(Cantante, Cantidad),
    Cantidad >= CantidadMinimaCanciones.

cantidadCanciones(Cantante, Cantidad):-
    findall(Cancion, vocaloid(Cantante, Cancion), ListaCanciones),
    length(ListaCanciones, Cantidad).
    
cumpleTiempoTotal(Cantante, MinimaDuracion):-
    tiempoCantante(Cantante, DuracionTotal),
    DuracionTotal >= MinimaDuracion.

%%RequisitosConciertoMediano

cumpleRequisitosConcierto(Cantante, mediano(TiempoMaximo)):-
    tiempoCantante(Cantante, DuracionTotal),
    DuracionTotal <= TiempoMaximo.

cumpleRequisitosConcierto(Cantante, pequenio(Duracion)):-
    duracionCancion(Cantante, DuracionCancion),
    DuracionCancion > Duracion.


/*Conocer el vocaloid más famoso, es decir con mayor nivel de fama. El nivel de fama 
de un vocaloid se calcula como la fama total que le dan los conciertos en los cuales puede participar
 multiplicado por la cantidad de canciones que sabe cantar.
*/
nivelDeFama(Vocaloid, NivelDeFama):-
    famaPorConcierto(Vocaloid, FamaPorConcierto),
    cantidadCanciones(Vocaloid, CantidadCanciones),
    NivelDeFama is FamaPorConcierto * CantidadCanciones.

famaPorConcierto(Vocaloid, FamaPorConcierto):-
    puedeParticiparEn(Concierto, Vocaloid),
    findall(Fama, concierto(Concierto, _, Fama, _), ListaDeFama),
    sum_list(ListaDeFama, FamaPorConcierto).
    
%Con Forall
vocaloidMasFamoso(Vocaloid):-
    nivelDeFama(Vocaloid, NivelDeFama),
forall((nivelDeFama(OtroVocaloid, OtroNivelDeFama), Vocaloid \= OtroVocaloid), NivelDeFama > OtroNivelDeFama).

% Con Negacion
vocaloidMasFamoso(Vocaloid):-
    nivelDeFama(Vocaloid, NivelDeFama)
    not((nivelDeFama(OtroVocaloid, OtroNivelDeFama), OtroNivelDeFama > NivelDeFama).











    



