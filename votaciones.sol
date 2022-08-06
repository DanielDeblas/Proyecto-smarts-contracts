//Daniel Deblas Payo.
//Proyecto Bachillerato
//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;
pragma experimental ABIEncoderV2;


    


contract votaciones {


    address public owner;

   constructor () public{
        owner = msg.sender;
    } 
    
    
    mapping (string=> bytes32) IDCandidato;
    mapping (string=>uint) VotosRecibidos;
    
    
    string [] candidatos; 
    bytes32 [] votantes;

    //Funciones---------------------------------------

    function PresentarCandidatura (string memory nombre, uint edad, string memory ID) public{
            
            bytes32 HashCandidato = keccak256(abi.encodePacked(nombre, edad, ID));
            IDCandidato[nombre] = HashCandidato;

            candidatos.push(nombre);

    }


    function CandidatosPresesntados() public view returns(string [] memory ) {
            return candidatos;
    }

    function votar(string memory candidato) public {
        
        bytes32 HashVotante = keccak256(abi.encodePacked(msg.sender));
        
        for(uint j=0; j<votantes.length; j++){
            require (votantes[j] != HashVotante, "Este usuario ya ha emitido su voto"); 
        }

        votantes.push(HashVotante);
        VotosRecibidos[candidato]++; 
    }



    function NumeroVotos (string memory candidato) public view returns(uint){
        return VotosRecibidos[candidato];
    }

    


    //-------------------------------------------------------------------------------------------------------------------
    // Obtenido de: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol#L15-L35
   function toString(uint256 value) internal pure returns (string memory) {

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
//-------------------------------------------------------------------------------------------------------------------------------



    function Resultados() public view returns (string memory){
        
        string memory resultados;
    
        for(uint j=0; j<candidatos.length; j++){
                resultados = string(abi.encodePacked(resultados,  "---", candidatos[j], toString(NumeroVotos(candidatos[j]))));

        }
            return resultados;

    }
    
    function GanadorElecciones() public view returns (string memory){

        string memory ganador = candidatos[0]; 
        bool flag; 

        for(uint j=1; j<candidatos.length; j++){
            if(VotosRecibidos[ganador] < VotosRecibidos[candidatos[j]]){
                ganador = candidatos[j];
                flag = false;
            }else{
                if(VotosRecibidos[ganador] == VotosRecibidos[candidatos[j]]){
                    flag = true;
                }
            }

        }
        if(flag==true){
            ganador = "Se ha producido un empate";
        }
        return ganador;

    }


}


