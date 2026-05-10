CREATE DATABASE lovelace;
USE lovelace;
CREATE TABLE Usuario(
ci INT PRIMARY KEY NOT NULL,
pwd VARCHAR(128) NOT NULL,
email VARCHAR(255) NOT NULL UNIQUE,
nombre CHAR(20) NOT NULL,
apellido CHAR(20) NOT NULL,
fnac DATE NOT NULL,
rolCandidato ENUM ('administrativo', 'analista', 'entrenador', 'juez', 'jugador', 'scout'),
tokenLogin varchar(16) UNIQUE
);
CREATE TABLE Administrativo(
CIAdministrativo INT PRIMARY KEY,
FOREIGN KEY (CIAdministrativo) REFERENCES Usuario(CI)
);
CREATE TABLE Analista(
CIAnalista INT PRIMARY KEY,
FOREIGN KEY (CIAnalista) REFERENCES Usuario(CI)
);
CREATE TABLE Entrenador(
CIEntrenador INT PRIMARY KEY,
FOREIGN KEY (CIEntrenador) REFERENCES Usuario(CI)
);
CREATE TABLE Juez(
CIJuez INT PRIMARY KEY,
FOREIGN KEY (CIJuez) REFERENCES Usuario(CI)
);
CREATE TABLE Scout(
CIScout INT PRIMARY KEY,
FOREIGN KEY (CIScout) REFERENCES Usuario(CI)
);
CREATE TABLE Jugador(
CIJugador INT PRIMARY KEY,
Altura DECIMAL(3, 2) NOT NULL,
Peso DECIMAL(5, 2) NOT NULL,
FOREIGN KEY (CIJugador) REFERENCES Usuario(CI)
);
CREATE TABLE Ticket(
idTicket INT PRIMARY KEY AUTO_INCREMENT,
consulta CHAR(255),
estado ENUM ('Pendiente', 'Revisado'),
motivo ENUM ('Queja', 'Sugerencia'),
CI INT NOT NULL,
FOREIGN KEY (CI) REFERENCES Usuario(CI)
);
CREATE TABLE Atiende(
idTicket INT NOT NULL PRIMARY KEY,
CIAdministrativo INT NOT NULL,
FOREIGN KEY (CIAdministrativo) REFERENCES Administrativo(CIAdministrativo),
FOREIGN KEY (idTicket) REFERENCES Ticket(idTicket)
);
CREATE TABLE Recluta(
CIScout INT NOT NULL,
CIJugador  INT NOT NULL,
fechaHora DATETIME NOT NULL,
PRIMARY KEY(CIScout, CIJugador),
FOREIGN KEY (CIScout) REFERENCES Scout(CIScout),
FOREIGN KEY (CIJugador) REFERENCES Jugador(CIJugador)
);
CREATE TABLE Valida(
CIUsuario INT NOT NULL PRIMARY KEY,
CIAdministrativo INT,
Estado ENUM('Pendiente', 'Rechazado', 'Validado'),
Detalle VARCHAR(255),
FOREIGN KEY (CIUsuario) REFERENCES Usuario(CI),
FOREIGN KEY (CIAdministrativo) REFERENCES Administrativo(CIAdministrativo)
);

CREATE TABLE Deporte(
idDeporte INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
nombre char(20) NOT NULL UNIQUE,
descripcion varchar(255) NOT NULL
);
CREATE TABLE Equipo(
idEquipo INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
nombre char(40) NOT NULL,
idDeporte INT NOT NULL,
CIEntrenador INT NOT NULL,
FOREIGN KEY (idDeporte) REFERENCES Deporte(idDeporte),
FOREIGN KEY (CIEntrenador) REFERENCES Entrenador(CIEntrenador)
);
CREATE TABLE Posicion(
idPosicion INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
nombre char(25) NOT NULL,
idDeporte INT NOT NULL,
FOREIGN KEY (idDeporte) REFERENCES Deporte(idDeporte)
);
CREATE TABLE Pertenece(
CIJugador INT NOT NULL,
idEquipo INT NOT NULL,
idPosicion INT NOT NULL,
numCamiseta INT,
PRIMARY KEY(CIJugador, idEquipo, idPosicion),
FOREIGN KEY (CIJugador) REFERENCES Jugador(CIJugador),
FOREIGN KEY (idEquipo) REFERENCES Equipo(idEquipo),
FOREIGN KEY (idPosicion) REFERENCES Posicion(idPosicion)
);
CREATE TABLE Partido(
idPartido INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
resLocal INT UNSIGNED NOT NULL DEFAULT 0,
resVisitante INT UNSIGNED NOT NULL DEFAULT 0,
fechaHoraInicio DATETIME NOT NULL,
horaFinal TIME,
estado ENUM ('Pendiente','En progreso', 'Tiempo fuera', 'Finalizado'),
tipo ENUM ('Octavos', 'Cuartos', 'Semifinal', 'Final', 'Amistoso'),
idDeporte INT NOT NULL,
locatario INT,
visitante INT,
CIJuez INT NOT NULL,
CIAnalista INT NOT NULL,
FOREIGN KEY (idDeporte) REFERENCES Deporte(idDeporte),
FOREIGN KEY (locatario) REFERENCES Equipo(idEquipo),
FOREIGN KEY (visitante) REFERENCES Equipo(idEquipo),
FOREIGN KEY (CIJuez) REFERENCES Juez(CIJuez),
FOREIGN KEY (CIAnalista) REFERENCES Analista(CIAnalista)
);
CREATE TABLE Juega(
CIJugador int NOT NULL,
idPartido int NOT NULL,
PRIMARY KEY(CIJugador, idPartido),
FOREIGN KEY (CIJugador) REFERENCES Jugador(CIJugador),
FOREIGN KEY (idPartido) REFERENCES Partido(idPartido)
);
CREATE TABLE tiempoFuera(
idTF INT AUTO_INCREMENT PRIMARY KEY,
horaInicio TIME NOT NULL,
horaFinal TIME,
idPartido INT NOT NULL,
FOREIGN KEY (idPartido) REFERENCES Partido(idPartido)
);
CREATE TABLE tipoGol(
idTG INT AUTO_INCREMENT PRIMARY KEY,
nombre CHAR(15) NOT NULL,
valor INT NOT NULL,
idDeporte INT NOT NULL,
FOREIGN KEY (idDeporte) REFERENCES Deporte(idDeporte)
);
CREATE TABLE Gol(
idGol INT AUTO_INCREMENT PRIMARY KEY,
minuto TIME NOT NULL,
idTG INT NOT NULL,
idPartido INT NOT NULL,
CIJugador INT NOT NULL,
FOREIGN KEY (idTG) REFERENCES tipoGol(idTG),
FOREIGN KEY (idPartido) REFERENCES Partido(idPartido),
FOREIGN KEY (CIJugador) REFERENCES Jugador(CIJugador)
);

CREATE TABLE tipoIncidencia(
idTipoIncidencia INT AUTO_INCREMENT PRIMARY KEY,
nombre char(20) NOT NULL,
idDeporte INT NOT NULL,
FOREIGN KEY (idDeporte) REFERENCES Deporte(idDeporte)
);
CREATE TABLE Incidencia(
idIncidencia INT AUTO_INCREMENT PRIMARY KEY,
tiempo TIME NOT NULL,
observaciones varchar(255) NOT NULL,
estado ENUM ('Pendiente', 'Validada'),
idTipoIncidencia INT NOT NULL,
CIAnalista INT NOT NULL,
idPartido INT NOT NULL,
FOREIGN KEY (idTipoIncidencia) REFERENCES tipoIncidencia(idTipoIncidencia),
FOREIGN KEY (CIAnalista) REFERENCES Analista(CIAnalista),
FOREIGN KEY (idPartido) REFERENCES Partido(idPartido)
);
CREATE TABLE Comprueba(
idIncidencia INT NOT NULL PRIMARY KEY,
CIJuez INT NOT NULL,
FOREIGN KEY (CIJuez) REFERENCES Juez(CIJuez),
FOREIGN KEY (idIncidencia) REFERENCES Incidencia(idIncidencia)
);
CREATE TABLE Recibe(
idIncidencia INT NOT NULL PRIMARY KEY,
idEquipo INT NOT NULL,
CIJugador INT NOT NULL,
FOREIGN KEY (CIJugador) REFERENCES Jugador(CIJugador),
FOREIGN KEY (idEquipo) REFERENCES Equipo(idEquipo),
FOREIGN KEY (idIncidencia) REFERENCES Incidencia(idIncidencia)
);
CREATE TABLE Torneo(
idTorneo INT AUTO_INCREMENT PRIMARY KEY,
nombre CHAR(50),
estado ENUM ('Pendiente', 'En progreso', 'Finalizado')
);
CREATE TABLE Compone(
idPartido INT NOT NULL PRIMARY KEY,
idTorneo INT NOT NULL,
grupo ENUM ('A','B','C','D','E','F','G','H') NOT NULL,
FOREIGN KEY (idPartido) REFERENCES Partido(idPartido),
FOREIGN KEY (idTorneo) REFERENCES Torneo(idTorneo)
);
