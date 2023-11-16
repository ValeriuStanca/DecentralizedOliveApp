App ={

    contracts : {},
    loadEthereum: async () => {
        if (typeof window.ethereum !== 'undefined') {
            console.log('La red Ethereum existe y se encuentra disponible');
            App.web3provider = window.ethereum;
    
            try {
                await window.ethereum.request({ method: 'eth_requestAccounts' });
            } catch (error) {
                console.error('El usuario rechazó la conexión a MetaMask');
            }
        } else {
            console.log('No se encontró la red Ethereum. Se recomienda instalar MetaMask');
        }
    },

    loadContracts : async () =>{

       const res = await fetch("OlivaContract.json")
       const OlivaContractJson =  await res.json()
       App.contracts.olivaContract = TruffleContract(OlivaContractJson)
       App.contracts.olivaContract.setProvider(App.web3provider)
       App.Olivacontract = await App.contracts.olivaContract.deployed()
       console.log(OlivaContractJson)
    },
    loadWallet: async() =>{
        const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
        App.account = accounts[0]; 
        console.log( App.account);
        document.getElementById('account').innerText = App.account;
    },
    listaTareas : async()=>{
        

    },
    createProduct: async (Id, title, date, price) => {
        const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
        
        if (accounts.length > 0) {
            const fromAddress = accounts[0];
            const result = await App.Olivacontract.crearProducto(Id, title, date, price, { from: fromAddress });
            console.log(result.logs[0].args);
        } else {
            console.error('No se obtuvieron cuentas de MetaMask.');
        }

    
    }

}
 App.loadEthereum()
 App.loadContracts()
 App.loadWallet()
