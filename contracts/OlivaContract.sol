// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract OlivaContract {
    uint256 public BotellasCreadas = 0;
    address public owner;
    
    address[] public CertificadoresAutorizados;

    struct DatosSensor {
        uint timestamp;
        uint temperatura;
        uint humedad;
        uint presion;
    }

    struct BotellaAceite {
        string nombreProducto;
        uint fechaProduccion;
        uint nivelDeCertificacion;
        uint precioSalida;
        bool estaCertificado;
        DatosSensor[] datosSensores;
    }

    mapping(string => BotellaAceite) public botellasAceite; // Asociamos cada producto a una dirección

    event ProductoCreado(string idProducto, string nombreProducto, uint fechaProduccion, uint precioSalida);
    event ProductoCertificado(string idProducto, uint nivelDeCertificacion);
    event DatosSensoresRegistrados(string idProducto, uint marcaDeTiempo, uint temperatura, uint humedad, uint presion);

    constructor() {
        owner = msg.sender;
    }

    modifier soloPropietario() {
        require(msg.sender == owner, "**USO PIVILEGIADO**,Solo el propietario del contrato puede llamar a esta funcion");
        _;
    }
    modifier soloCertificadorAutorizado() {
        require(soyCertificadorAutorizado(msg.sender) , "**USO PIVILEGIADO**,Solo los certificadores autorizados registrados del contrato puede llamar a esta funcion");
        _;
    }
    function soyCertificadorAutorizado(address certifier) public view returns (bool) {
        for (uint i = 0; i < CertificadoresAutorizados.length; i++) {
            if (CertificadoresAutorizados[i] == certifier) {
                return true;
            }
        }
        return false;
    }

    function anadeCertificadorAutorizado(address certifier) external soloPropietario {
        require(!soyCertificadorAutorizado(certifier), "Esta direccion ya pertenece a una entidad certificadora");
        CertificadoresAutorizados.push(certifier);
    }
    
    function crearProducto(string memory idProducto, string memory nombreProducto, uint fechaProduccion, uint precioSalida) external soloPropietario {
        require(bytes(botellasAceite[idProducto].nombreProducto).length == 0, "Ya existe una botella de aceite con el mismo identificador");

        BotellaAceite storage nuevaBotella = botellasAceite[idProducto];
        nuevaBotella.nombreProducto = nombreProducto;
        nuevaBotella.fechaProduccion = fechaProduccion;
        nuevaBotella.nivelDeCertificacion = 0;
        nuevaBotella.estaCertificado = false;
        nuevaBotella.precioSalida = precioSalida;
        emit ProductoCreado(idProducto, nombreProducto, fechaProduccion, precioSalida);
    }

    function certificarProducto(string memory idProducto, uint nivelDeCertificacion) external soloPropietario {
        require(bytes(botellasAceite[idProducto].nombreProducto).length != 0, "El producto no existe o aun no ha sido creado");

        botellasAceite[idProducto].nivelDeCertificacion = nivelDeCertificacion;
        botellasAceite[idProducto].estaCertificado = true;

        emit ProductoCertificado(idProducto, nivelDeCertificacion);
    }

    function registrarDatosSensores(string memory idProducto, uint timestamp, uint temperatura, uint humedad, uint presion) external soloPropietario {
        require(bytes(botellasAceite[idProducto].nombreProducto).length != 0, "El producto no existe o aun no ha sido creado");

        DatosSensor memory nuevosDatos = DatosSensor({
            timestamp: timestamp,
            temperatura: temperatura,
            humedad: humedad,
            presion: presion
        });

        botellasAceite[idProducto].datosSensores.push(nuevosDatos);

        emit DatosSensoresRegistrados(idProducto, timestamp, temperatura, humedad, presion);
    }

    function obtenerCantidadDatosSensores(string memory idProducto) external view returns (uint) {
        return botellasAceite[idProducto].datosSensores.length;
    }

}
