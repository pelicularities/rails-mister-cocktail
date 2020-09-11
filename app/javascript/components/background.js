const randomCocktailBackground = () => {
  const maxNum = 11;
  let num = Math.ceil(Math.random() * maxNum);
  const assetPath = `/assets/backgrounds/background${num}.jpg`;
  document.body.style.backgroundImage = url(assetPath);
}

export { randomCocktailBackground }
