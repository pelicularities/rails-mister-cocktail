const randomCocktailBackground = () => {
  const maxNum = 11;
  let num = Math.ceil(Math.random() * maxNum);
  const bgClass = `bg-${num}`;
  document.body.classList.add(bgClass);
}

export { randomCocktailBackground }
