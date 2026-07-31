module.exports = function (eleventyConfig) {
  eleventyConfig.addPassthroughCopy("src/css/*");
  eleventyConfig.addPassthroughCopy("src/oidc");
  return {
    dir: {
      input: "src",
      output: "public",
    },
  };
};
