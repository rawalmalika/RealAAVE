import { Actor, HttpAgent } from '@dfinity/agent';
import { idlFactory as Aave_idl, canisterId as Aave_id } from 'dfx-generated/Aave';

const agent = new HttpAgent();
const Aave = Actor.createActor(Aave_idl, { agent, canisterId: Aave_id });

document.getElementById("clickMeBtn").addEventListener("click", async () => {
  const name = document.getElementById("name").value.toString();
  const greeting = await Aave.greet(name);

  document.getElementById("greeting").innerText = greeting;
});
