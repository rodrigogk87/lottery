import './App.css';
import { ethers } from 'ethers';
import LotteriArtifact from './artifacts/contracts/Lottery.sol/Lottery.json';

const LOTTERY_ADDRESS = "0x79ACb0F9E25B75690E2cd5d3DE87D26C5b443B00";

function App() {

  const requestAccount = async () => {
    await window.ethereum.request({ method: 'eth_requestAccounts' });
  }

  const participate = async () => {
    //ethereum is usable, get reference to the contract
    await requestAccount();
    const provider = new ethers.providers.Web3Provider(window.ethereum);

    //signer needed for transaction that changes state
    const signer = provider.getSigner();
    const contract = new ethers.Contract(LOTTERY_ADDRESS, LotteriArtifact.abi, signer);

    //preform transaction
    const enter_transaction = await contract.enter({ value: ethers.utils.parseUnits("0.005", "ether") });
    let tx = await enter_transaction.wait();

    console.log("ticket", tx);


  }


  const winner = async () => {
    //ethereum is usable, get reference to the contract
    await requestAccount();
    const provider = new ethers.providers.Web3Provider(window.ethereum);

    //signer needed for transaction that changes state
    const signer = provider.getSigner();
    const contract = new ethers.Contract(LOTTERY_ADDRESS, LotteriArtifact.abi, signer);

    //preform transaction
    const enter_transaction = await contract.pickWinner();
    let tx = await enter_transaction.wait();

    console.log("winner", tx);

  }

  return (
    <div className="App">
      lottery
      <button onClick={() => participate()}>Get a ticket</button>

      <button onClick={() => winner()}>pick winner</button>
    </div>
  );
}

export default App;
