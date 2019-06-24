import { Elm } from '../elm/Main.elm';

const mainContent = document.querySelector('#main') || document.body;
const elmNode = document.createElement('div');
mainContent.appendChild(elmNode);

const app = Elm.Main.init({
    node: elmNode,
});

export { app };
