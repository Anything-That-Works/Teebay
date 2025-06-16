PART 1:
- Used Combine to provide user with the issues with the input in the Registration form, could have been done easier using .onChange but Combine provided more control on the delay in checks 
- APIServices was used to isolate all the Network calls for ease of testing
    - improvement: using #if DEBUG it would be easier to work on the forntend development after functions tested
- AppError class should be able to address all of the possible errors
- Mostly used async-await to ensure nesting level in code remains under control and the code itself is readable.
- Biomatric was done in a rush and can be improved for more fluid flow of the views
- View components that were used in multiple places were seperated into thair own structs for reusability.

PART 2:
- Similar to part one, each of the requests are done within APIServices
- For each model, encoding and decoding are handled in extension to seperate concerns and increase readability, static data provided for previews

PART 3:
- Users product list and all product list was complete, rest of the processes including transaction is mostly incomplete.
