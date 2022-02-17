let Web3 = require('web3')

const getWeb3 = () => {
    return new Promise((resolve, reject) => {
        window.addEventListener("load", async() => {
            if (window.ethereum) {
                const web3 = new Web3(window.ethereum);
                try {
                    // ask user permission to access his accounts
                    await window.ethereum.request({ method: "eth_requestAccounts" });
                    resolve(web3);
                } catch (error) {
                    reject(error);
                }
            } else {
                reject("must install MetaMask");
            }
        });
    });
};

const getContract = async(web3) => {
    const data = await $.getJSON("./build/contracts/Coin.json");

    const netId = await web3.eth.net.getId();
    const deployedNetwork = data.networks[netId];


    const meta = new web3.eth.Contract(
        data.abi,
        deployedNetwork.address
    );
    //  deployedNetwork && 
    return meta;
};

const displayBalance = async(balance, contract) => {

    balance = await contract.methods.getBalance().call();
    $("#pool").html(balance);


    let rand = await contract.methods.random().call();

    console.log(rand)

};


const updatePlayers = async(contract) => {
    let count = await contract.methods.getPlayersCount().call();

    if (count > 0)
        for (let i = 0; i < count; i++) {
            let player = await contract.methods.players(i).call();
            let state = "";
            if (player.winner_state) {
                state = "winner!";
            } else {
                state = "loser :("
            }

            $("#players").append(`<div><h3>${moment.unix(player.time)}</h3><a href="https://rinkeby.etherscan.io/address/${player.p_hash}">${player.p_hash}</a><h4>${state}</h4> <h2>${player.tax}</h2></div>`);
        }
        // 



}



const play = async(web3, balance, contract, accounts) => {



    $("#form").on("submit", async(e) => {
        let bet = $("#bet").val();
        let state_selector = $("#states-select option:selected").text();

        let state = true;
        if (bet == "") {
            alert("Please enter a bet");
            return;
        }
        if (state_selector == "Up") {
            state = true;
        } else {
            state = false;
        }


        e.preventDefault();

        await contract.methods.play(state).send({
            from: accounts[0],
            value: web3.utils.toWei(bet, "gwei")
        }).on('receipt', function(res) {
            updatePlayers(contract);
            console.log("Block hash: " + res.blockHash)
        });

        displayBalance(balance, contract);
    });
};



const donate = (web3, balance, contract, accounts) => {

    $("#donate").on("click", async(e) => {
        e.preventDefault();
        try {

            await contract.methods.payPoolContract().send({
                from: accounts[0],
                value: web3.utils.toWei("10000", "gwei")
            }).on('receipt', function() {
                alert("Thanks for donation!");
            });


            displayBalance(balance, contract);
        } catch (e) {
            console.log(e);
        }

    });

}

async function App() {
    const web3 = await getWeb3();
    const accounts = await web3.eth.getAccounts();
    const contract = await getContract(web3);

    let balance;

    updatePlayers(contract);
    displayBalance(balance, contract);
    play(web3, balance, contract, accounts);
    donate(web3, balance, contract, accounts);
}

App();